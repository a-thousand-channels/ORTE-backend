json.extract! layer, :id, :title, :text, :published, :map_id, :color, :created_at, :updated_at
json.url map_layer_url(layer, format: :json)
json.places layer.places do |place|
  json.extract! place, :id, :title, :teaser, :text, :link, :startdate, :enddate, :lat, :lon, :full_address, :location, :address, :zip, :city, :country, :published, :layer_id, :created_at, :updated_at, :date, :edit_link, :show_link, :imagelink2, :imagelink
end
