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
    mapcenter_lat { '0.1' }
    mapcenter_lon { '10' }
    zoom { 12 }
    popup_display_mode { 'click' }
    tooltip_display_mode { 'false' }
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
