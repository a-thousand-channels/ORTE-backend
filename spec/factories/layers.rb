# frozen_string_literal: true

FactoryBot.define do
  factory :layer do
    title { 'MyString' }
    subtitle { 'MyString' }
    text { 'MyString' }
    teaser { 'MyTeaser' }
    credits { 'MyString' }
    style { 'MyCSS' }
    published { false }
    basemap_url { 'MyBasemapUrl' }
    basemap_attribution { 'Basemap made by' }
    color { '#cc0000' }
    background_color { '#454545' }
    mapcenter_lat { '0.1' }
    mapcenter_lon { '10' }
    zoom { 12 }
    tooltip_display_mode { 'false' }
    places_sort_order { 'startdate' }
    rasterize_images { false }
    submission_config { false }
    map

    trait :invalid do
      title { nil }
    end
    trait :changed do
      title { 'OtherTitle' }
    end
  end
end
