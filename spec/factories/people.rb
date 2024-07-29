# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    name { 'MyString' }
    info { 'MyText' }
    map
    trait :invalid do
      name { nil }
    end
    trait :changed do
      name { 'OtherName' }
    end
  end
end
