# frozen_string_literal: true

json.place do
  next unless @place.published

  json.call(@place, :id, :uid, :title, :subtitle, :teaser, :text, :sources, :link, :imagelink, :imagelink2, :audiolink, :audiolinks, :published, :date, :date_with_qualifier, :startdate, :enddate, :startdate_qualifier, :enddate_qualifier, :location, :address, :zip, :city, :text, :country, :featured, :layer_id, :layer_title, :color, :icon_link, :icon_class, :icon_name)

  json.localized_versions do
    I18n.available_locales.each do |locale|
      Mobility.with_locale(locale) do
        json.set! locale do
          json.title @place.localized_title
          json.subtitle @place.localized_subtitle
          json.teaser @place.localized_teaser
          json.text @place.localized_text
          json.sources @place.localized_sources
        end
      end
    end
  end
end
