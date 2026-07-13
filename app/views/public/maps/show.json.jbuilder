# frozen_string_literal: true

json.map do
  next unless @map.published

  json.call(@map, :id, :title, :subtitle, :text, :credits, :image_link, :created_at, :updated_at, :published)
  json.owner @map.group.title
  json.iconset @map.iconset, :title, :icon_anchor, :icon_size, :popup_anchor, :class_name if @map.iconset
  json.layer do
    json.array! @map_layers do |layer|
      next unless layer.published

      json.call(layer, :id, :title, :subtitle, :text, :teaser, :credits, :image_link, :color, :created_at, :updated_at, :published)
      json.places do
        json.array! layer.places do |place|
          next unless place.published

          json.call(place, :id, :uid, :title, :subtitle, :teaser, :text, :sources, :link, :imagelink, :imagelink2, :audiolink, :audiolinks, :published, :date_with_qualifier, :startdate, :enddate, :location, :address, :zip, :city, :text, :country, :featured, :shy, :layer_id, :icon_link, :icon_class, :icon_name)
          json.lat place.public_lat
          json.lon place.public_lon
          json.tags place.tags.map(&:name).sort
          json.pages place.pages do |page|
            next unless page.published

            json.extract! page, :id, :title, :subtitle, :text, :teaser, :footer, :created_at, :updated_at, :published
          end
          json.annotations place.annotations do |annotation|
            json.extract! annotation, :id, :title, :text, :person_name, :audiolink
          end
          json.audios place.audios do |audio|
            json.extract! audio, :id, :title, :source, :creator, :alt, :sorting, :audio_url, :audio_linktag, :locale
          end
          json.images do
            json.array!(place.images.sort_by { |image| [image.sorting ? 0 : 1, image.sorting] }) do |image|
              json.call(image, :id, :title, :source, :creator, :alt, :sorting, :image_linktag, :image_url)
            end
          end
          if @map.primary_language.present?
            locales = if @map.available_languages.present?
                        langs = @map.available_languages.is_a?(Array) ? @map.available_languages : @map.available_languages.split(',')
                        langs.map { |l| l.is_a?(String) ? l.strip : l }
                      else
                        I18n.available_locales
                      end

            json.localized_versions do
              locales.each do |locale|
                Mobility.with_locale(locale) do
                  json.set! locale do
                    json.title place.localized_title
                    json.subtitle place.localized_subtitle
                    json.teaser place.localized_teaser
                    json.text place.localized_text
                    json.sources place.localized_sources
                  end
                end
              end
            end
          end
        end
      end
      json.places_with_relations layer.places do |place|
        next unless place.published

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
  json.pages do
    json.array! @map.pages do |page|
      next unless page.published

      json.call(page, :id, :title, :subtitle, :text, :teaser, :footer, :created_at, :updated_at, :published)
    end
  end
end
