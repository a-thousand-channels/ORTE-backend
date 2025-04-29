# frozen_string_literal: true

require 'csv'

include ActionView::Helpers::SanitizeHelper

class Imports::CsvImporter
  attr_reader :valid_rows, :invalid_rows, :duplicate_rows, :errored_rows, :unprocessable_fields, :error

  REQUIRED_FIELDS = %w[title lat lon].freeze

  ALLOWED_FIELDS = %w[title subtitle teaser text link startdate startdate_date startdate_time enddate enddate_date enddate_time lat lon location address zip city country published featured sensitive sensitive_radius shy imagelink layer_id icon_id relations_tos relations_froms tag_list].freeze

  PREVIEW_FIELDS = %w[title lat lon location address zip city country].freeze

  # TODO: update existing place as an option

  def initialize(file, layer_id, overwrite: false)
    @file = file
    @layer = Layer.find(layer_id)
    @overwrite = overwrite
    @invalid_rows = []
    @duplicate_rows = []
    @valid_rows = []
    @errored_rows = []
    @existing_titles = @layer.places ? @layer.places.pluck(:title) : []
    @unprocessable_fields = []
  end

  def import
    validate_header
    CSV.foreach(@file.path, headers: true) do |row|
      processed_row = row.to_hash.slice(*ALLOWED_FIELDS)
      Rails.logger.info('Process row')

      unless !processed_row.empty? && valid_row?(processed_row)
        @invalid_rows << processed_row
        next
      end

      processed_row['tag_list'] = processed_row['tag_list'].split(',').map(&:strip) if processed_row['tag_list'].present?

      # dupe handling
      title = do_sanitize(processed_row['title'])

      if @existing_titles.include?(title) && @overwrite == false
        # skip existing rows with this title
        @duplicate_rows << processed_row
        error_hash = { data: processed_row, type: 'Duplicate', messages: ['Title already exists'] }
        @errored_rows << error_hash
      else
        @existing_titles << title
        processed_row['title'] = title
        processed_row['teaser'] = do_sanitize(processed_row['teaser']) if processed_row['teaser'].present?
        @valid_rows << processed_row
      end
    end
    if @valid_rows.empty?
      Rails.logger.info('CSV import returns no valid rows!')
    elsif @invalid_rows.empty?
      Rails.logger.info('CSV import completed successfully!')
    end
    return if @invalid_rows.empty?

    handle_invalid_rows
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
    place = Place.new(title: row['title'], lat: row['lat'], lon: row['lon'], layer_id: @layer.id)
    place.valid?
  end

  def handle_invalid_rows
    @invalid_rows.map do |row|
      place = Place.new(title: row['title'], lat: row['lat'], lon: row['lon'], layer_id: @layer.id)
      unless place.valid?
        error_hash = { data: row, type: 'Invalid data', messages: place.errors.full_messages }
        @errored_rows << error_hash
      end
    end

    @errored_rows.each_with_index do |row, index|
      Rails.logger.error("Invalid row #{index + 1}: #{@invalid_rows[index]} - Errors: #{row['messages']}")
    end
  end

  def do_sanitize(value)
    # call rails sanitizer + strip string
    sanitize(value).strip
  end
end
