# frozen_string_literal: true

FactoryBot.define do
  factory :video do
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
      after(:build) do |video|
        video.file.attach(
          io: File.open(Rails.root.join('spec/support/files/test.mp4')),
          filename: 'test.txt',
          content_type: 'video/mp4'
        )
      end
    end
    trait :without_file do
      file { [] }
    end
    trait :with_wrong_fileformat do
      after(:build) do |post|
        post.file.attach(
          io: File.open(Rails.root.join('spec/support/files/test.txt')),
          filename: 'test.txt',
          content_type: 'image/jpeg'
        )
      end
    end
    trait :invalid do
      title { nil }
      place { nil }
      file { [] }
    end
    trait :changed do
      title { 'OtherTitle' }
    end
  end
end
