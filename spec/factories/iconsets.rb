# frozen_string_literal: true

FactoryBot.define do
  factory :iconset do
    title { 'MyString' }
    text { 'MyText' }
    trait :invalid do
      title { nil }
    end
    trait :changed do
      title { 'OtherTitle' }
    end
  end
end
