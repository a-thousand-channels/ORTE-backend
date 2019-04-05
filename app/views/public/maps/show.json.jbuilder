json.map do
  next unless @map.published
  json.(@map, :id, :title, :text, :created_at, :updated_at, :published)
  json.owner @map.group.title

  json.layer do
    json.array! @map.layers.published do |layer|
      next unless layer.published
      json.(layer, :id, :title, :text, :created_at, :updated_at, :published)
      json.places do
        json.array! layer.places.published do |place|
          next unless place.published
          json.(place, :id, :title, :teaser, :link, :imagelink, :published, :startdate, :enddate, :lat, :lon, :location, :address, :zip, :city, :text, :country, :layer_id)
        end
      end
    end
  end
end