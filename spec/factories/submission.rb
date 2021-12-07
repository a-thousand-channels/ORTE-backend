# frozen_string_literal: true

FactoryBot.define do
  factory :submission do
    name { 'MyString' }
    email { 'email@domain.org' }
    rights { true }
    privacy { true }
    locale { 'en' }
    status {0}
    place
  end
end
