# frozen_string_literal: true

FactoryBot.define do
  factory :map do
    title { 'MyString' }
    subtitle { 'MyString' }
    text { 'MyString' }
    teaser { 'MyTeaser' }
    credits { 'MyString' }
    style { 'MyCSS' }
    published { false }
    basemap_url { 'MyBasemapUrl' }
    basemap_attribution { 'Basemap made by' }
    color { '#0000cc' }
    background_color { '#151515' }
    mapcenter_lat { '0.1' }
    mapcenter_lon { '10' }
    zoom { 12 }
    popup_display_mode { 'click' }
    tooltip_display_mode { 'false' }
    places_sort_order { 'startdate' }
    group
    trait :invalid do
      title { nil }
    end
    trait :update do
      title { 'MyNewString' }
    end
  end
end
