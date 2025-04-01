# frozen_string_literal: true

json.extract! map, :id, :title, :subtitle, :text, :credits, :image_link, :published, :group_id, :created_at, :updated_at, :show_annotations_on_map
json.url map_url(map, format: :json)
json.layers map.layers do |layer|
  json.extract! layer, :id, :title, :subtitle, :text, :credits, :image_link, :published, :map_id, :color, :relations_bending, :relations_coloring, :image_alt, :image_licence, :image_source, :image_creator, :image_caption, :created_at, :updated_at, :ltype
  json.iconset layer.map.iconset, :title, :icon_anchor, :icon_size, :popup_anchor, :class_name if layer.map.iconset

  places_query = layer.places
  puts '------------------------'
  puts 'JBUILDER'
  puts "places: #{places_query.count}"
  puts "search: #{@search}"

  if @search.present?
    puts "search: #{@search}"
    places_query = places_query.where('title LIKE :query OR teaser LIKE :query OR text LIKE :query', query: "%#{@search}%")
    puts "places: #{places_query.count}"
  end
  if @tag_name.present?
    puts "tag_name: #{@tag_name}"
    places_query = places_query.tagged_with(@tag_name)
    puts "places: #{places_query.count}"
  end
  puts "places: #{places_query.count}"
  json.places do
    json.array! places_query do |place|
      json.extract! place, :id, :title, :subtitle, :teaser, :text, :sources, :link, :startdate, :enddate, :full_address, :location, :address, :zip, :city, :country, :published, :featured, :shy, :layer_id, :layer_title, :layer_color, :layer_type, :created_at, :updated_at, :date, :url, :edit_link, :show_link, :imagelink2, :imagelink, :icon_link, :icon_class, :icon_name, :tags
      json.lat place.public_lat
      json.lon place.public_lon
      json.annotations do
        json.array! place.annotations do |annotation|
          json.extract! annotation, :id, :title, :text, :person_name, :audiolink
        end
      end
    end
  end
  json.places_with_relations do
    json.array! layer.places do |place|
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
  json.places_by_year @places_by_year do |year, places|
    json.set! year, places
  end
end
