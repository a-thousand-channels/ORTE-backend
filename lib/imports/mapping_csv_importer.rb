# frozen_string_literal: true
require 'csv'

class Imports::MappingCsvImporter
  attr_reader :valid_rows, :invalid_rows, :duplicate_rows, :errored_rows, :unprocessable_fields, :error

  def initialize(file, layer_id, import_mapping, overwrite: false, col_sep: ',', quote_char: '"', row_sep: "\n")
    @file = file
    @layer = Layer.find(layer_id)
    @import_mapping = import_mapping
    @overwrite = overwrite
    @invalid_rows = []
    @duplicate_rows = []
    @valid_rows = []
    @errored_rows = []
    @unprocessable_fields = []
    @col_sep = col_sep
    @row_sep = row_sep
    @quote_char = quote_char
  end

  def import
    CSV.foreach(@file.path, headers: true, col_sep: @col_sep, quote_char: @quote_char, row_sep: @row_sep).with_index do |row, index|
      begin
        processed_row = { layer_id: @layer.id }
        mappings = @import_mapping.mapping
        mappings.each do |mapping|
          csv_column_name = mapping["csv_column_name"]
          model_property = mapping["model_property"]
          value = @import_mapping.parse(row[csv_column_name], mapping["parsers"])
          processed_row[model_property] = value
        end

        # TODO: header validieren und Error werfen?!
        Rails.logger.info('Process row')
        if processed_row["tags"]
          tags = processed_row["tags"]&.split(',')&.map(&:strip)
          place = Place.new(processed_row.except("tags"))
          place.tag_list = tags if tags.present?
        else
          place = Place.new(processed_row)
        end
        if place.valid?
          @valid_rows << place
        else
          @invalid_rows << place
        end
        identical_fields = @import_mapping.mapping.select { |mapping| mapping['key'] }.map { |mapping| mapping['model_property'] }.to_h {
          |key| [key, place[key]]
        }
        @duplicate_rows << place if Place.where(identical_fields).exists? # todo: auf key anpassen, hash der spaltenname aus db auf wert aus csv mappt
        puts "Identical fields: #{identical_fields}"
      rescue StandardError => e
        @errored_rows << row
      end
    end
  end
end
