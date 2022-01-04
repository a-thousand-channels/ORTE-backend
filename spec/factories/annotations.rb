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
      audio { [fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'test.mp3'), 'audio/mpeg')] }
    end
    trait :invalid do
      text { nil }
    end
    trait :changed do
      text { 'OtherText' }
    end
  end
end
