# frozen_string_literal: true

FactoryBot.define do
  factory :import_mapping do
    name { Faker::App.name }
    mapping do
      [
        { csv_column_name: 'title', model_property: 'title', key: true },
        { csv_column_name: 'lon', model_property: 'lon', key: false },
        { csv_column_name: 'lat', model_property: 'lat', key: false }
      ]
    end
    trait :with_parsers do
      mapping do
        [
          { csv_column_name: 'title', model_property: 'title', parsers: ['sanitize', 'trim'], key: true },
          { csv_column_name: 'lon', model_property: 'lon', key: false },
          { csv_column_name: 'lat', model_property: 'lat', key: false }
        ]
      end
    end
  end
end

# warum mapping, wenn csv_column_name und model_property gleich sind?