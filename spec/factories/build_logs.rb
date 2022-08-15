# frozen_string_literal: true

FactoryBot.define do
  factory :build_log do
    map
    layer
    output { 'MyString' }
    size { 'MyString' }
    version { 'MyString' }
    trait :changed do
      output { 'OtherString' }
    end
  end
end
