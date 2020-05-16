# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    title { 'MyString' }
    trait :invalid do
      title { nil }
    end
    trait :update do
      title { 'MyNewString' }
    end
  end
end
