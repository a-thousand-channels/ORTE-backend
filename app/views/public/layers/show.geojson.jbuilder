# frozen_string_literal: true

if @layer&.published
  json.type 'FeatureCollection'
  json.title @layer.title
  json.text @layer.text
  json.id @layer.id

  json.features @layer.places do |place|
    next unless place.published

    json.type 'Feature'
    json.geometry do
      json.type 'Point'
      json.coordinates [place.public_lon.to_i, place.public_lat.to_i]
    end
    json.properties do
      json.id place.id
      json.name place.title
      json.address place.address
      json.city place.city
      json.country place.country
      json.teaser place.teaser
      json.text place.text
      json.link place.link
      json.images do
        json.array! place.images do |image|
          json.call(image, :id, :title, :source, :creator, :alt, :sorting, :image_linktag, :image_url)
        end
      end
    end
  end
end
