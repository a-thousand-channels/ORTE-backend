# frozen_string_literal: true

json.map do
  next unless @map.published

  json.call(@map, :id, :title, :subtitle, :text, :credits, :image_link, :created_at, :updated_at, :published)
  json.owner @map.group.title
  json.iconset @map.iconset, :title, :icon_anchor, :icon_size, :popup_anchor, :class_name if @map.iconset
  json.layer do
    json.array! @map.layers.published do |layer|
      next unless layer.published

      json.call(layer, :id, :title, :subtitle, :text, :credits, :image_link, :color, :created_at, :updated_at, :published)
      json.places do
        json.array! layer.places.published do |place|
          next unless place.published

          json.call(place, :id, :title, :teaser, :link, :imagelink, :imagelink2, :audiolink, :published, :startdate, :enddate, :location, :address, :zip, :city, :text, :country, :featured, :shy, :layer_id, :icon_link, :icon_class, :icon_name)
          json.lat place.public_lat
          json.lon place.public_lon
          json.annotations place.annotations do |annotation|
            json.extract! annotation, :id, :title, :text, :person_name, :audiolink
          end
          json.images do
            json.array! place.images.order('sorting ASC') do |image|
              json.call(image, :id, :title, :source, :creator, :alt, :sorting, :image_linktag, :image_url)
            end
          end
        end
      end
      json.places_with_relations layer.places.published do |place|
        next unless place.published

        if place.relations_froms.count.positive?
          json.relations place.relations_froms do |relation|
            json.id relation.id
            json.from do
              json.extract! relation.relation_from, :id
              json.lat relation.relation_from.public_lat
              json.lon relation.relation_from.public_lon
            end
            json.to do
              json.extract! relation.relation_to, :id
              json.lat relation.relation_to.public_lat
              json.lon relation.relation_to.public_lon
            end
          end
        end
      end
    end
  end
end
