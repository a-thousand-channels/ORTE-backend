# frozen_string_literal: true

class ImportMapping < ApplicationRecord
  validate :validate_required_model_properties
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
    parsers = parser_names&.map { |parser_name| self.class.parsers[parser_name][:lambda] } || []
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
        'trim' => { lambda: lambda(&:strip), description: 'Removes leading and trailing whitespace.' },
        'strip_html_tags' => { lambda: ->(value) { value&.gsub(/<\/?[^>]*>/, '') }, description: 'Removes HTML tags from the text.' },
        'remove_leading_hash' => { lambda: ->(value) { value&.gsub(/#\b/, '') || '' }, description: 'Removes leading hash symbols (#).' },
        'spaces_to_commas' => { lambda: ->(value) { value&.gsub(/\s+/, ',') }, description: 'Replaces spaces with commas.' },
        'split_to_first' => { lambda: ->(value) { value.split(',').first }, description: 'Takes the first value from a comma-separated list.' },
        'split_to_last' => { lambda: ->(value) { value.split(',').last }, description: 'Takes the last value from a comma-separated list.' },
        'european_date' => { lambda: ->(value) { DateTime.strptime(value, '%d.%m.%Y') }, description: 'Parses a date in European format (DD.MM.YYYY).' },
        'american_date' => { lambda: ->(value) { DateTime.parse(value) }, description: 'Parses a date in American format (MM/DD/YYYY).' }
      }
    end
  end

  def validate_required_model_properties
    required_properties = %w[title lat lon]
    mappings = mapping || []
    missing_properties = required_properties - mappings.map { |m| m['model_property'] }

    return unless missing_properties.any?

    errors.add(:mapping, "is missing required properties: #{missing_properties.join(', ')}")
  end
end
