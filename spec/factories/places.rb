# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    title { 'MyTitle' }
    subtitle { 'MySubTitle' }
    teaser { 'MyText' }
    text { 'MyText' }
    link { 'http://domain.com' }
    startdate { '2018-04-27 19:48:51' }
    enddate { '2018-04-27 19:48:51' }
    lat { '0' }
    lon { '0' }
    direction { '320' }
    location { 'Location' }
    address { 'Address' }
    zip { 'Zip' }
    city { 'City' }
    country { 'Country' }
    published { false }
    imagelink { 'Some link' }
    layer
    trait :published do
      published { true }
    end
    trait :date_and_time do
      startdate_date { '2018-04-30' }
      startdate_time { '11:45' }
    end
    trait :invalid do
      title { nil }
    end
    trait :changed do
      title { 'OtherTitle' }
    end
    trait :changed_and_published do
      title { 'OtherTitle' }
      published { true }
    end
    trait :with_audio do
      after(:build) do |place|
        place.audio.attach(
          io: File.open(Rails.root.join('spec/support/files/test.mp3')),
          filename: 'test.mp3',
          content_type: 'audio/mpeg'
        )
      end
    end
    trait :with_images do
      # deprecated
      after(:build) do |place|
        place.file.attach(
          io: File.open(Rails.root.join('spec/support/files/test.jpg')),
          filename: 'test.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
