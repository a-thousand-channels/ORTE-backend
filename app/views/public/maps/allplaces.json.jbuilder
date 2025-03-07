# frozen_string_literal: true

json.map do
  next unless @map.published

  json.call(@map, :id, :title, :subtitle, :text, :credits, :image_link, :created_at, :updated_at, :published)
  json.owner @map.group.title
  json.iconset @map.iconset, :title, :icon_anchor, :icon_size, :popup_anchor, :class_name if @map.iconset

  json.places do
    json.array! @allplaces do |place|
      next unless place.published

      json.call(place, :id, :title, :subtitle, :teaser, :link, :imagelink, :imagelink2, :audiolink, :published, :startdate, :enddate, :location, :address, :zip, :city, :text, :country, :featured, :shy, :icon_link, :icon_class, :icon_name, :layer_id, :layer_title, :layer_slug, :color)
      json.lat place.public_lat
      json.lon place.public_lon
      json.annotations place.annotations do |annotation|
        json.extract! annotation, :id, :title, :text, :person_name, :audiolink
      end
      json.images do
        json.array!(place.images.sort_by { |image| [image.sorting ? 0 : 1, image.sorting] }) do |image|
          json.call(image, :id, :title, :source, :creator, :alt, :sorting, :image_linktag, :image_url)
        end
      end
      if place.relations_froms.size.positive?
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
