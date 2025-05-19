# frozen_string_literal: true

require 'csv'

module Imports
  class MappingCsvImporter
    include ActionView::Helpers::SanitizeHelper
    include ImportContextHelper
    attr_reader :valid_rows, :duplicate_rows, :invalid_duplicate_rows, :errored_rows, :ambiguous_rows, :missing_fields, :error

    REQUIRED_FIELDS = %w[title lat lon].freeze

    PREVIEW_FIELDS = %w[uid title teaser lat lon location address zip city country tag_list].freeze

    def initialize(file, layer_id, import_mapping, overwrite: false, col_sep: ',', quote_char: '"', row_sep: "\n")
      @file = file
      @layer = Layer.find(layer_id)
      @import_mapping = import_mapping
      @overwrite = overwrite
      @duplicate_rows = []
      @valid_rows = []
      @invalid_duplicate_rows = []
      @errored_rows = []
      @ambiguous_rows = []
      @missing_fields = []
      @col_sep = col_sep
      @row_sep = row_sep
      @quote_char = quote_char
    end

    def import
      headers = CSV.read(@file.path, headers: true, col_sep: @col_sep, quote_char: @quote_char).headers
      @missing_fields = REQUIRED_FIELDS - headers
      csv_content = @file.read.force_encoding('UTF-8').scrub.gsub(/\r\n?/, "\n")
      csv = CSV.parse(csv_content, headers: true, col_sep: @col_sep, quote_char: @quote_char, row_sep: @row_sep)
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
            processed_row[model_property] = do_sanitize(processed_row[model_property])
          rescue StandardError => e
            parsing_errors[model_property] = e.message
          end
        end
        processed_row = processed_row.reject { |key, _| key.to_s.strip.empty? }
        place = Place.new(processed_row)
        place.validate
        parsing_errors.each do |key, error|
          place.errors.add(key, error)
        end
        duplicate_count = duplicate_key_values(@import_mapping, place) && Place.where(duplicate_key_values(@import_mapping, place)).count
        if duplicate_count == 1
          if place.valid?
            duplicate_hash = { data: row, duplicate_id: Place.where(duplicate_key_values(@import_mapping, place)).first.id, place: place }
            @duplicate_rows << duplicate_hash
          elsif place.errors.count == 1 && place.errors.full_messages.first == 'Id has already been taken'
            duplicate_hash = { data: row, duplicate_id: Place.where(duplicate_key_values(@import_mapping, place)).first.id, place: place }
            @duplicate_rows << duplicate_hash
          else
            duplicate_hash = { data: row, duplicate_id: Place.where(duplicate_key_values(@import_mapping, place)).first.id, messages: [place.errors.full_messages] }
            @invalid_duplicate_rows << duplicate_hash
          end
        elsif duplicate_count && duplicate_count > 1
          ambiguous_hash = { data: row, duplicate_count: duplicate_count }
          @ambiguous_rows << ambiguous_hash
        elsif place.errors.any?
          error_hash = { data: row, messages: [place.errors.full_messages] }
          @errored_rows << error_hash
        elsif place.valid?
          @valid_rows << place
        else
          error_hash = { data: row, messages: ['unknown error'] }
          @errored_rows << error_hash
        end
      rescue StandardError => e
        error_hash = { data: row, messages: [e.message] }
        @errored_rows << error_hash
      end
    end

    def do_sanitize(value)
      if value.is_a?(String)
        # call rails sanitizer to remove potential malicious input + strip string
        sanitize(value).strip
      else
        value
      end
    end
  end
end
