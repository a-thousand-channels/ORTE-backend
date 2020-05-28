# frozen_string_literal: true

FactoryBot.define do
  factory :map do
    title { 'MyString' }
    subtitle { 'MyString' }
    text { 'MyString' }
    published { false }
    group
    trait :invalid do
      title { nil }
    end
    trait :update do
      title { 'MyNewString' }
    end
  end
end
