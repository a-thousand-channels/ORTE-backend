# frozen_string_literal: true

FactoryBot.define do
  factory :annotation do
    title { 'MyString' }
    text { 'MyText' }
    published { '' }
    sorting { 1 }
    source { 'MyText' }
    place
    person
    trait :with_audio do
      after(:build) do |annotation|
        annotation.audio.attach(
          io: File.open(Rails.root.join('spec/support/files/test.mp3')),
          filename: 'test.mp3',
          content_type: 'audio/mpeg'
        )
      end
    end
    trait :invalid do
      text { nil }
    end
    trait :changed do
      text { 'OtherText' }
    end
  end
end
