json.extract! place, :id, :title, :teaser, :text, :link, :startdate, :enddate, :lat, :lon, :full_address, :location, :address, :zip, :city, :country, :published, :layer_id, :created_at, :updated_at
json.url place_url(place, format: :json)
