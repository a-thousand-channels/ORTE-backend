# frozen_string_literal: true

FactoryBot.define do
  factory :tag, :class => ActsAsTaggableOn::Tag do |f|
    f.sequence(:name) { |n| "tag#{n}" }
  end
end
