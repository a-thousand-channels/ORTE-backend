# frozen_string_literal: true

require 'csv'

namespace :geocode do
  desc 'Geocode addresses,add lat/lon columns and separate address components'
  task addresses_in_csv_and_separate: :environment do
    input_file = Rails.root.join('tmp', 'input_tryout.csv')
    output_file = Rails.root.join('tmp', 'output.csv')
    CSV.open(output_file, 'w') do |csv_out|
      csv_out << %w[title link full_address category published text date_published address city state zip lat lon]
      CSV.foreach(input_file, headers: true) do |row|
        # wait 1 sec, to avoid hitting rate limit
        sleep(1.2)
        full_address = row['address']
        lookup_address = full_address.gsub(/,[^,]*$/, '')
        address_parts = full_address.split(',').map(&:strip)

        address = address_parts[0]
        city = address_parts[1]
        state_zip = address_parts[2].split(' ')
        state = state_zip[0]
        zip = state_zip[1]

        # Geocode full address
        begin
          puts "Looking up: #{lookup_address}"
          results = Geocoder.search(lookup_address)
        rescue StandardError => e
          puts "Error geocoding address: #{e.message}"
          results = []
          # skip to next row
          next
        end

        if results.any?
          lat = results.first.latitude
          lon = results.first.longitude
        else
          lat = ''
          lon = ''
        end

        csv_out << row.fields + [address, city, state, zip, lat, lon]
        puts "Processed: #{lookup_address}"
      end
    end

    puts "Geocoding complete. Output saved to #{output_file}"
  end
end
