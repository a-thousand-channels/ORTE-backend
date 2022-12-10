# frozen_string_literal: true

json.layer do
  next unless @layer.published

  json.call(@layer, :id, :title, :subtitle, :text, :teaser, :credits, :image_link, :image_filename, :backgroundimage_link, :backgroundimage_filename, :favicon_link, :favicon_filename, :color, :style, :basemap_url, :basemap_attribution, :background_color, :tooltip_display_mode, :mapcenter_lat, :mapcenter_lon, :zoom, :relations_bending, :relations_coloring, :created_at, :updated_at, :published)
  json.places do
    json.array! @places do |place|
      next unless place.published

      json.call(place, :id, :title, :subtitle, :teaser, :link, :imagelink, :imagelink2, :audiolink, :published, :startdate, :enddate, :location, :address, :zip, :city, :text, :country, :featured, :layer_id, :icon_link, :icon_class, :icon_name)
      json.lat place.public_lat
      json.lon place.public_lon
      json.annotations place.annotations do |annotation|
        json.extract! annotation, :id, :title, :text, :person_name, :audiolink
      end
      json.images do
        json.array! place.images.order('sorting ASC') do |image|
          json.call(image, :id, :title, :source, :creator, :alt, :sorting, :image_linktag, :image_url, :image_path, :image_filename, :image_on_disk)
        end
      end
    end
  end
  json.places_with_relations @places do |place|
    next unless place.published

    if place.relations_froms.count.positive?
      json.relations place.relations_froms do |relation|
        json.id relation.id
        json.from do
          json.extract! relation.relation_from, :id, :title, :show_link, :published, :layer_id
          json.lat relation.relation_from.public_lat
          json.lon relation.relation_from.public_lon
        end
        json.to do
          json.extract! relation.relation_to, :id, :title, :show_link, :published, :layer_id
          json.lat relation.relation_to.public_lat
          json.lon relation.relation_to.public_lon
        end
      end
    end
  end
end
