# frozen_string_literal: true

require 'csv'

include ActionView::Helpers::SanitizeHelper

class Imports::CsvImporter
  attr_reader :invalid_rows

  REQUIRED_FIELDS = %w[title lat lon].freeze

  ALLOWED_FIELDS = %w[title subtitle teaser text link startdate startdate_date startdate_time enddate enddate_date enddate_time lat lon location address zip city country published featured sensitive sensitive_radius shy imagelink layer_id icon_id relations_tos relations_froms].freeze

  TEXT_FIELDS = %w[title subtitle teaser text location address zip city country].freeze

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
      processed_row = row.to_hash.slice(*ALLOWED_FIELDS)

      unless !processed_row.empty? && valid_row?(processed_row)
        @invalid_rows << processed_row
        next
      end

      # dupe handling
      title = sanitize(processed_row['title'])

      if @existing_titles.include?(title)
        # TODO!
        # skip existing rows with this title
        @invalid_rows << processed_row
        # else
        # update existing row
        # @existing_titles << title
      else
        @existing_titles << title
        create_place(processed_row)
      end
    end

    if @invalid_rows.empty?
      Rails.logger.info('CSV import completed successfully!')
    else
      handle_invalid_rows
    end
  end

  private

  def required_fields_present?(row)
    REQUIRED_FIELDS.all? { |field| row[field].present? }
  end

  def validate_header
    headers = CSV.read(@file.path, headers: true).headers
    missing_fields = REQUIRED_FIELDS - headers

    raise StandardError, "Missing required fields: #{missing_fields.join(', ')}" if missing_fields.any?

    processable_fields = headers - ALLOWED_FIELDS

    raise StandardError, 'Now allowed fields found if missing_fields.any?' if processable_fields.empty?
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

  def create_place(row)
    place_attrs = {}
    ALLOWED_FIELDS.each do |field|
      puts "#{field} #{row[field]}"
      if TEXT_FIELDS.include?(field)
        place_attrs[field.to_sym] = strip_tags(row[field]).strip if row[field]
      elsif row[field]
        place_attrs[field.to_sym] = sanitize(row[field])
      end
    end
    place_attrs[:layer_id] = @layer.id unless place_attrs[:layer_id]

    place = Place.new(place_attrs)
    place.save
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
