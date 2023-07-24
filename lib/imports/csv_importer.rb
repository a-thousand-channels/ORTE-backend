# frozen_string_literal: true

require 'csv'

include ActionView::Helpers::SanitizeHelper

class Imports::CsvImporter
  attr_reader :invalid_rows, :unprocessable_fields # values needed for testing

  REQUIRED_FIELDS = %w[title lat lon].freeze

  ALLOWED_FIELDS = %w[title subtitle teaser text link startdate startdate_date startdate_time enddate enddate_date enddate_time lat lon location address zip city country published featured sensitive sensitive_radius shy imagelink layer_id icon_id relations_tos relations_froms].freeze

  TEXT_FIELDS = %w[title subtitle teaser text location address zip city country].freeze

  # TODO: param: update or skip existing place?

  def initialize(file, layer_id)
    @file = file
    @invalid_rows = []
    @layer = Layer.find(layer_id)
    @existing_titles = []
    @unprocessable_fields = []
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
      title = do_sanitize(processed_row['title'])

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

    @unprocessable_fields = headers - ALLOWED_FIELDS
    Rails.logger.error('Not allowed fields found (and skipped)') unless @unprocessable_fields.empty?

    processable_fields = headers - @unprocessable_fields
    raise StandardError, 'No allowed fields found' if processable_fields.empty?
  end

  def valid_row?(row)
    place = Place.new(title: do_sanitize(row['title']), lat: do_sanitize(row['lat']), lon: do_sanitize(row['lon']), layer_id: @layer.id)
    place.valid?
  end

  def create_place(row)
    place_attrs = {}
    ALLOWED_FIELDS.each do |field|
      puts "#{field} #{row[field]}"
      if TEXT_FIELDS.include?(field)
        place_attrs[field.to_sym] = strip_tags(row[field]).strip if row[field]
      elsif row[field]
        place_attrs[field.to_sym] = do_sanitize(row[field])
      end
    end
    place_attrs[:layer_id] = @layer.id unless place_attrs[:layer_id]

    place = Place.new(place_attrs)
    place.save
  end

  def handle_invalid_rows
    error_messages = @invalid_rows.map do |row|
      place = Place.new(title: do_sanitize(row['title']), lat: do_sanitize(row['lat']), lon: do_sanitize(row['lon']), layer_id: @layer.id)
      place.valid?
      place.errors.full_messages
    end

    error_messages.each_with_index do |messages, index|
      Rails.logger.error("Invalid row #{index + 1}: #{@invalid_rows[index]} - Errors: #{messages.join(', ')}")
    end
  end

  def do_sanitize(value)
    # call rails sanitizer
    sanitize(value).strip
  end
end
