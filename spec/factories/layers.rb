# frozen_string_literal: true

FactoryBot.define do
  factory :layer do
    title { 'MyString' }
    subtitle { 'MyString' }    
    text { 'MyString' }
    published { false }
    map
    submission_config {false}
    trait :invalid do
      title { nil }
    end
    trait :changed do
      title { 'OtherTitle' }
    end
  end
end
