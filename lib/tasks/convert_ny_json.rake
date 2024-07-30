require 'json'
require 'csv'

namespace :json_to_csv do
  desc 'Convert JSON to CSV'
  task convert: :environment do
    json_file = Rails.root.join('tmp', 'import_with_coord.json')
    csv_file = Rails.root.join('tmp', 'output_from_json.csv')

    # Read and parse JSON
    json_data = JSON.parse(File.read(json_file))

    # Flatten JSON if necessary (example for simple flattening)
    # flattened_data = flatten_json(json_data)
    flattened_data = json_data.map { |item| flatten_json(item) }

    # Write to CSV
    CSV.open(csv_file, 'wb') do |csv|
      # Write headers
      csv << 'title,link,full_address,category,published,text,date_published,address,city,state,zip,lat,lon'.split(',')
      # Write data rows
      flattened_data.each do |row|
        if row['address.geocoded.formatted_address']
          full_address = row['address.geocoded.formatted_address']
          address_parts = full_address.split(',').map(&:strip)
          address = address_parts[0]
          city = address_parts[1]
          if address_parts[2].nil?
            puts "Error: #{lookup_address}"
            error_counter += 1
            next
          end
          state_zip = address_parts[2].split(' ')
          state = state_zip[0]
          zip = state_zip[1]
        end
        lat = row['address.geocoded.lat'] if row['address.geocoded.lat']
        lon = row['address.geocoded.lng'] if row['address.geocoded.lng']
        title = row['name'] if row['name']
        link = row['link'] if row['link']
        text = row['description'] if row['description']
        published = true if row['verified']
        date_published = row['date_posted.iso'] if row['date_posted.iso']
        category = row['category'] if row['category']

        crow = title, link, full_address, category, published, text, date_published, address, city, state, zip, lat, lon
        csv << crow

        # csv << row.values
      end
    end

    puts "Conversion completed. CSV file saved at #{csv_file}"
  end

  def flatten_json(json_obj, parent_key = '', result = {})
    json_obj.each do |key, value|
      current_key = parent_key.empty? ? key : "#{parent_key}.#{key}"

      if value.is_a?(Hash)
        flatten_json(value, current_key, result)
      elsif value.is_a?(Array)
        result[current_key] = value.join(', ')
      else
        result[current_key] = value
      end
    end
    result
  end
end
