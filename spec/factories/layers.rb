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
    color { '#cc0000' }
    use_background_from_parent_map { false }
    basemap_url { 'MyLayerBasemapUrl' }
    basemap_attribution { 'Basemap made by' }
    background_color { '#454545' }
    mapcenter_lat { '0.1' }
    mapcenter_lon { '10' }
    zoom { 12 }
    tooltip_display_mode { 'false' }
    places_sort_order { false }
    rasterize_images { false }
    submission_config { false }
    exif_remove { true }
    image_alt { 'An alternative text' }
    image_licence { 'An image licence' }
    image_source { 'The image source' }
    image_creator { 'The creator of the image' }
    image_caption { 'A caption for this image' }
    map

    trait :use_background_from_parent_map do
      use_background_from_parent_map { true }
    end

    trait :with_no_color do
      color { false }
    end

    trait :with_wrong_color_format do
      color { 'cc0000' }
    end

    trait :sorted_by_title do
      places_sort_order { 'title' }
    end

    trait :sorted_by_startdate do
      places_sort_order { 'startdate' }
    end

    trait :with_image do
      image { [fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'test.jpg'), 'image/jpeg')] }
    end
    trait :without_image do
      image { [] }
    end
    trait :with_backgroundimage do
      backgroundimage { [fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'test.jpg'), 'image/jpeg')] }
    end
    trait :with_favicon do
      favicon { [fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'test.jpg'), 'image/jpeg')] }
    end

    trait :invalid do
      title { nil }
    end
    trait :changed do
      title { 'OtherTitle' }
    end
  end
end
