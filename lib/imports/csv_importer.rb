# frozen_string_literal: true

require 'csv'

include ActionView::Helpers::SanitizeHelper

class Imports::CsvImporter
  attr_reader :invalid_rows

  REQUIRED_FIELDS = %w[title lat lon].freeze

  ALLOWED_FIELDS = %(title subtitle teaser text link startdate startdate_date startdate_time enddate enddate_date enddate_time lat lon location address zip city country published featured sensitive sensitive_radius shy imagelink layer_id icon_id relations_tos relations_froms)

  # TODO: param: update or skip existing place?

  def initialize(file, layer_id)
    @file = file
    @invalid_rows = []
    @layer = Layer.find(layer_id)
    @existing_titles = []
  end

  def import
    validate_header

    CSV.foreach(@file.path, headers: true) do |row|
      unless valid_row?(row)
        @invalid_rows << row
        next
      end

      title = sanitize(row['title'])
      if @existing_titles.include?(title)
        @invalid_rows << row
        # else
        # FIXME
        # @existing_titles << title
      end
    end

    if @invalid_rows.empty?
      process_valid_rows
      Rails.logger.info('CSV import completed successfully!')
    else
      handle_invalid_rows
    end
  end

  private

  def validate_header
    headers = CSV.read(@file.path, headers: true).headers
    missing_fields = REQUIRED_FIELDS - headers

    raise StandardError, "Missing required fields: #{missing_fields.join(', ')}" if missing_fields.any?
  end

  def valid_row?(row)
    place = Place.new(title: sanitize(row['title']), lat: sanitize(row['lat']), lon: sanitize(row['lon']), layer_id: @layer.id)
    place.valid?
  end

  def process_valid_rows
    CSV.foreach(@file.path, headers: true) do |row|
      title = sanitize(row['title'])
      if @existing_titles.include?(title)
        Rails.logger.error("Place already exists! #{title}")
      else
        # TODO: write all fields within ALLOWED_FIELDS array
        place = Place.new(title: title, teaser: strip_tags(row['teaser']).strip, lat: sanitize(row['lat']), lon: sanitize(row['lon']), layer_id: @layer.id)
        place.save!
        @existing_titles << title
      end
    end
  end

  def handle_invalid_rows
    error_messages = @invalid_rows.map do |row|
      place = Place.new(title: sanitize(row['title']), lat: sanitize(row['lat']), lon: sanitize(row['lon']), layer_id: @layer.id)
      place.valid?
      place.errors.full_messages
    end

    # Implement how you want to handle the invalid rows
    # For example, you can log the error messages or store them in a separate file
    error_messages.each_with_index do |messages, index|
      Rails.logger.error("Invalid row #{index + 1}: #{@invalid_rows[index]} - Errors: #{messages.join(', ')}")
    end
  end

  def sanitize(value)
    # Implement any sanitization logic you require
    # strip leading/trailing whitespace: value.strip
    value.strip
  end
end
