# frozen_string_literal: true

json.layer do
  next unless @layer.published

  json.call(@layer, :id, :title, :subtitle, :text, :credits, :image_link, :color, :mapcenter_lat, :mapcenter_lon, :zoom, :created_at, :updated_at, :published)
  json.places do
    json.array! @layer.places.published do |place|
      next unless place.published

      json.call(place, :id, :title, :teaser, :link, :imagelink, :imagelink2, :audiolink, :published, :startdate, :enddate, :lat, :lon, :location, :address, :zip, :city, :text, :country, :featured, :layer_id, :icon_link, :icon_class, :icon_name)
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
  json.places_with_relations @layer.places.published do |place|
    next unless place.published

    if place.relations_froms.count.positive?
      json.relations place.relations_froms do |relation|
        json.id relation.id
        json.from do
          json.extract! relation.relation_from, :id, :lat, :lon, :title, :show_link, :published, :layer_id
        end
        json.to do
          json.extract! relation.relation_to, :id, :lat, :lon, :title, :show_link, :published, :layer_id
        end
      end
    end
  end
end
