# frozen_string_literal: true

require 'csv'

class Imports::CsvImporter
  attr_reader :invalid_rows

  def initialize(file, layer_id)
    @file = file
    @invalid_rows = []
    @layer = Layer.find(layer_id)
    @existing_titles = []
  end

  def import
    CSV.foreach(@file.path, headers: true) do |row|
      unless valid_row?(row)
        @invalid_rows << row
        next
      end

      title = sanitize(row['title'])
      if @existing_titles.include?(title)
        @invalid_rows << row
      else
        @existing_titles << title
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

  def valid_row?(row)
    place = Place.new(title: sanitize(row['title']), teaser: sanitize(row['teaser']), layer_id: @layer.id)
    place.valid?
  end

  def process_valid_rows
    CSV.foreach(@file.path, headers: true) do |row|
      title = sanitize(row['title'])
      if @existing_titles.include?(title)
        Rails.logger.error("Place already exists! #{title}")
        puts 'Place already exists'
      else
        place = Place.new(title: title, teaser: sanitize(row['teaser']), layer_id: @layer.id)
        place.save!
        @existing_titles << title
      end
    end
  end

  def handle_invalid_rows
    error_messages = @invalid_rows.map do |row|
      place = Place.new(title: sanitize(row['title']), teaser: sanitize(row['teaser']))
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
    # For example, you can strip leading/trailing whitespace: value.strip
    value
  end
end
