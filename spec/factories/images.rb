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
    itype { 'image' }
    trait :with_file do
      # file { Rack::Test::UploadedFile.new('spec/support/files/test.jpg', 'image/jpeg') }
      # file { attach(io: File.open(Rails.root.join('spec/support/files/test.jpg', 'test.jpg')) }
      after(:build) do |post|
        post.file.attach(
          io: File.open(Rails.root.join('spec/support/files/test.jpg')),
          filename: 'test.jpg',
          content_type: 'image/jpeg'
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
    trait :notitle do
      title { nil }
    end
    trait :nofile do
      file { [] }
    end
    trait :invalid do
      title { nil }
      place { nil }
      file { [] }
    end
    trait :changed do
      title { 'OtherTitle' }
    end
    trait :preview do
      preview { true }
    end
  end
end
