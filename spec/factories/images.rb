# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    title { 'Title' }
    licence { 'Licence' }
    source { 'Source' }
    creator { 'Creator' }
    place
    alt { 'Alt' }
    caption { 'Caption' }
    sorting { 2 }
    preview { false }
    trait :with_file do
      file { [fixture_file_upload(Rails.root.join('public', 'apple-touch-icon.png'), 'image/png')] }
    end
    trait :invalid do
      place { nil }
    end
    trait :changed do
      title { 'OtherTitle' }
    end
  end
end
