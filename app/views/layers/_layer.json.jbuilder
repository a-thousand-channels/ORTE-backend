json.extract! layer, :id, :title, :text, :published, :map_id, :created_at, :updated_at
json.url map_layer_url(layer, format: :json)
json.places layer.places do |place|
  json.extract! place, :id, :title, :teaser, :text, :link, :startdate, :enddate, :lat, :lon, :full_address, :location, :address, :zip, :city, :country, :published, :layer_id, :created_at, :updated_at, :date, :edit_link
  json.images(place.images) do |image|
    json.image_url url_for(image)
  end
end
