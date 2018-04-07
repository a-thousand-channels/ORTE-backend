# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password 'password12345'
    password_confirmation 'password12345'
  end

  factory :admin_user, class: User do
    # TODO: cancancan
    email
    password 'password'
  end
end
