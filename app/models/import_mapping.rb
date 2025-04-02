# frozen_string_literal: true

class ImportMapping < ApplicationRecord
  validate :validate_required_model_properties
  validates :name, presence: true
  validates :name, uniqueness: true

  private

  def validate_required_model_properties
    required_properties = %w[title lat lon]
    mappings = JSON.parse(mapping || '[]')
    missing_properties = required_properties - mappings.map { |m| m['model_property'] }

    if missing_properties.any?
      errors.add(:mapping, "is missing required properties: #{missing_properties.join(', ')}")
    end
  end
end
