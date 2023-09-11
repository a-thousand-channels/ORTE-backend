# frozen_string_literal: true

require 'nokogiri'

include ActionView::Helpers::SanitizeHelper

class Imports::KmlImporter
  attr_reader :valid_rows, :invalid_rows, :duplicate_rows, :errored_rows, :unprocessable_fields, :error

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
    kml_data = File.read(@file.path)
    validate_file(kml_data)

    doc = Nokogiri::XML(kml_data)

    # Process the KML data here and save it to your application's model
    # Example: Parse the KML data and save it to a Location model
    processed_row = {}
    Rails.logger.info('Process row')

    doc.css('Placemark').each do |placemark|
      processed_row['title'] = placemark.css('name').text
      coordinates = placemark.css('coordinates').text.split(',').map(&:strip)
      processed_row['lat'] = coordinates[1]
      processed_row['lon'] = coordinates[0] # KML uses (lon, lat) order

      # dupe handling
      title = do_sanitize(processed_row['title'])

      if @existing_titles.include?(title) && @overwrite == false
        # skip existing rows with this title
        @duplicate_rows << processed_row
        error_hash = { data: processed_row, type: 'Duplicate', messages: ['Title already exists'] }
        @errored_rows << error_hash
      else
        @existing_titles << title

        # TODO
        # processed_row['teaser'] = do_sanitize(processed_row['teaser']) if processed_row['teaser'].present?
        @valid_rows << processed_row
      end

      if @valid_rows.empty?
        Rails.logger.info('KML import returns no valid rows!')
      elsif @invalid_rows.empty?
        Rails.logger.info('KML import completed successfully!')
      end
      handle_invalid_rows
    end
  end

  private

  def validate_file(kml_data)
    # Check if the file starts with a KML opening tag
    raise StandardError, 'File does not contain KML-XML' unless kml_data.match?(/<kml\s+xmlns="http:\/\/www\.opengis\.net\/kml\/2\.2">/)

    # Use Nokogiri to check if it's valid XML
    begin
      Nokogiri::XML(kml_data)
      true
    rescue Nokogiri::XML::SyntaxError
      raise StandardError, 'File does not contain valid XML'
    end
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
