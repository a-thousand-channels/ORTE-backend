# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    title { 'MyString' }
    subtitle { 'MyString' }
    teaser { 'MyText' }
    text { 'MyText' }
    published { false }
    state { 'MyString' }
    map

    trait :invalid do
      title { nil }
    end

    trait :changed do
      title { 'OtherTitle' }
    end
  end
end
