# frozen_string_literal: true

require 'csv'

module Imports
  class MappingCsvImporter
    attr_reader :valid_rows, :invalid_rows, :duplicate_rows, :errored_rows, :ambiguous_rows, :unprocessable_fields, :error

    REQUIRED_FIELDS = %w[title lat lon].freeze

    ALLOWED_FIELDS = %w[title subtitle teaser text link startdate startdate_date startdate_time enddate enddate_date enddate_time lat lon location address zip city country published featured sensitive sensitive_radius shy imagelink layer_id icon_id relations_tos relations_froms tag_list].freeze

    PREVIEW_FIELDS = %w[uid title lat lon location address zip city country tag_list].freeze

    def initialize(file, layer_id, import_mapping, overwrite: false, col_sep: ',', quote_char: '"', row_sep: "\n")
      @file = file
      @layer = Layer.find(layer_id)
      @import_mapping = import_mapping
      @overwrite = overwrite
      @invalid_rows = []
      @duplicate_rows = []
      @valid_rows = []
      @errored_rows = []
      @ambiguous_rows = []
      @unprocessable_fields = []
      @col_sep = col_sep
      @row_sep = row_sep
      @quote_char = quote_char
    end

    # TODO: rename to preview_import? (analog with other importer)?
    def import
      csv_content = @file.read.force_encoding('UTF-8').scrub.gsub(/\r\n?/, "\n")
      csv = CSV.parse(csv_content, headers: true, col_sep: @col_sep, quote_char: @quote_char, row_sep: @row_sep)
      headers = csv.headers
      @unprocessable_fields = @import_mapping.unprocessable_fields(headers)

      csv.each do |row|
        processed_row = { layer_id: @layer.id }
        mappings = @import_mapping.mapping
        parsing_errors = {}
        mappings.each do |mapping|
          csv_column_name = mapping['csv_column_name']
          model_property = mapping['model_property']
          begin
            if mapping['parsers']
              value = @import_mapping.parse(row[csv_column_name], mapping['parsers'])
              processed_row[model_property] = value
            else
              processed_row[model_property] = row[csv_column_name]
            end
          rescue StandardError => e
            parsing_errors[model_property] = e.message
          end
        end
        place = Place.new(processed_row)
        place.validate
        parsing_errors.each do |key, error|
          place.errors.add(key, error)
        end
        duplicate_count = duplicate_key_values(place) && Place.where(duplicate_key_values(place)).count
        if duplicate_count == 1
          @duplicate_rows << place # TODO: im ui markieren, ob valid oder nicht, Zahl der validen kalkulieren
        elsif duplicate_count && duplicate_count > 1
          @ambiguous_rows << place # TODO: Testfälle
        elsif place.valid?
          @valid_rows << place # TODO: --> Zahl kalkulieren für UI/import-Vorschau
        else
          @invalid_rows << row
        end
      rescue StandardError => e
        @errored_rows << row
      end
    end

    def save_records
      @valid_rows.each(&:save)

      return unless @overwrite

      # TODO: filter auf valid rows
      @duplicate_rows.each do |place|
        existing_place = Place.find_by(duplicate_key_values(place))
        existing_place&.update(place.attributes)
      end
    end

    private

    def duplicate_key_values(place)
      key_mappings = @import_mapping.mapping.select { |mapping| mapping['key'] }
      return nil if key_mappings.empty?

      key_mappings.to_h do |mapping|
        [mapping['model_property'], place[mapping['model_property']]]
      end
    end
  end
end
