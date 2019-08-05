json.extract! map, :id, :title, :text, :published, :group_id, :created_at, :updated_at
json.url map_url(map, format: :json)
json.layers map.layers do |layer|
  if layer.published
    json.places layer.places do |place|
      if place.published
        json.extract! place, :id, :title, :teaser, :text, :link, :startdate, :enddate, :lat, :lon, :full_address, :location, :address, :zip, :city, :country, :published, :layer_id, :created_at, :updated_at, :date, :edit_link
        json.images(place.images) do |image|
          json.image_url url_for(image)
        end
      end
    end
  end
end