# frozen_string_literal: true

class ImportMapping < ApplicationRecord
  # validate :validate_required_model_properties # todo: klären, ob notwendig
  validates :name, presence: true
  validates :name, uniqueness: true

  def self.from_header(header_row)
    matching_headers = header_row.uniq.filter do |column_name|
      Place.column_names.map(&:downcase).include?(column_name.downcase)
    end.map do |column_name|
      {
        'csv_column_name' => column_name,
        'model_property' => Place.column_names.find { |col| col.casecmp(column_name).zero? },
        'parsers' => [],
        'key' => false
      }
    end
    ImportMapping.new(mapping: matching_headers)
  end

  def parse(value, parser_names)
    parser_names = JSON.parse(parser_names)
    parsers = parser_names&.map { |parser_name| self.class.parsers[parser_name] } || []
    parsers.each do |parser|
      value = parser.call(value) if parser
    end
    value
  end

  def unprocessable_fields(header_row)
    mappings = mapping || []
    mapped_headers = mappings.map { |m| m['csv_column_name'] }

    header_row - mapped_headers
  end

  private

  class << self
    def parsers
      @parsers ||= {
        'trim' => lambda(&:strip),
        'strip_html_tags' => ->(value) { value&.gsub(/<\/?[^>]*>/, '') },
        'remove_leading_hash' => ->(value) { value&.gsub(/#\b/, '') || '' },
        'spaces_to_commas' => ->(value) { value&.gsub(/\s+/, ',') },
        'split_to_first' => ->(value) { value.split(',').first },
        'split_to_last' => ->(value) { value.split(',').last },
        'european_date' => ->(value) { DateTime.strptime(value, '%d.%m.%Y') },
        'american_date' => ->(value) { DateTime.parse(value) }
      }
    end
  end

  # TODO: brauchen wir diese Validierung eigentlich? ggf. fixen
  def validate_required_model_properties
    required_properties = %w[title lat lon]
    mappings = mapping || []
    missing_properties = required_properties - mappings.map { |m| m['model_property'] }

    return unless missing_properties.any?

    errors.add(:mapping, "is missing required properties: #{missing_properties.join(', ')}")
  end
end
