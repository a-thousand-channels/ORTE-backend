# frozen_string_literal: true

class ImportMapping < ApplicationRecord
  validate :validate_required_model_properties
  validates :name, presence: true
  validates :name, uniqueness: true

  def parse(value, parser_names)
    parsers = parser_names&.map { |parser_name| @@parsers[parser_name] } || []
    parsers.each do |parser|
      value = parser.call(value) if parser
    end
    value
  rescue StandardError => e
    puts e.message
    Rails.logger.error("Error parsing value: #{e.message}")
    nil
  end

  private

  @@parsers = {
    'trim' => ->(value) { value.strip },
    'sanitize' => ->(value) { ActionController::Base.helpers.sanitize(value) }, # was soll genau machen?
    'remove_leading_hash' => ->(value) { value&.gsub(/#\b/, '') || '' },
    'spaces_to_commas' => ->(value) { value&.gsub(/\s+/, ',') },
    'split_to_first' => ->(value) { value.split(',').first },
    'split_to_last' => ->(value) { value.split(',').last },
    'european_date' => ->(value) { DateTime.strptime(value, '%d.%m.%Y') },
    'american_date' => ->(value) { DateTime.parse(value) }
  }
  def validate_required_model_properties
    required_properties = %w[title lat lon]
    mappings = mapping || []
    missing_properties = required_properties - mappings.map { |m| m['model_property'] }

    return unless missing_properties.any?

    errors.add(:mapping, "is missing required properties: #{missing_properties.join(', ')}")
  end
end
