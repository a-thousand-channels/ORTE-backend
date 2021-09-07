# frozen_string_literal: true

FactoryBot.define do
  factory :submission_config do
    title_intro { 'MyString' }
    subtitle_intro { 'MyString' }
    intro { 'MyText' }
    title_outro { 'MyString' }
    outro { 'MyText' }
    start_time { '2021-04-29 12:48:46' }
    end_time { '2021-04-29 12:48:46' }
    use_city_only { false }
  end
end
