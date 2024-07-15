require 'csv'

namespace :geocode do
  desc "Geocode addresses from CSV and add lat/lon columns"
  task :addresses_in_csv => :environment do
    input_file = Rails.root.join('tmp', 'input.csv')
    output_file = Rails.root.join('tmp', 'output.csv')

    CSV.open(output_file, 'w') do |csv_out|
      CSV.foreach(input_file, headers: true) do |row|
        if row.header_row?
          csv_out << row.headers + ['lat', 'lon']
        else
          address = row['address']
          results = Geocoder.search(address)

          if results.any?
            lat = results.first.latitude
            lon = results.first.longitude
          else
            lat = ''
            lon = ''
          end

          csv_out << row.fields + [lat, lon]
          puts "Processed: #{address}"
        end
      end
    end

    puts "Geocoding complete. Output saved to #{output_file}"
  end

  desc "Geocode addresses and separate address components"
  task :addresses_in_csv_and_separate => :environment do
    input_file = Rails.root.join('tmp', 'input.csv')
    output_file = Rails.root.join('tmp', 'output.csv')

    CSV.open(output_file, 'w') do |csv_out|
      CSV.foreach(input_file, headers: true) do |row|
        if row.header_row?
          csv_out << row.headers + ['address', 'city', 'state', 'zip', 'lat', 'lon']
        else
          full_address = row['address']
          address_parts = full_address.split(',').map(&:strip)
          
          address = address_parts[0]
          city = address_parts[1]
          state_zip = address_parts[2].split(' ')
          state = state_zip[0]
          zip = state_zip[1]

          results = Geocoder.search(full_address)

          if results.any?
            lat = results.first.latitude
            lon = results.first.longitude
          else
            lat = ''
            lon = ''
          end

          csv_out << row.fields + [address, city, state, zip, lat, lon]
          puts "Processed: #{full_address}"
        end
      end
    end

    puts "Geocoding complete. Output saved to #{output_file}"
  end
end