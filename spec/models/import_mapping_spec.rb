# frozen_string_literal: true

# spec/models/import_mapping_spec.rb
require 'rails_helper'

RSpec.describe ImportMapping, type: :model do
  describe 'validations' do
    let(:valid_mapping) do
      [
        { 'csv_column_name' => 'title', 'model_property' => 'title' },
        { 'csv_column_name' => 'lat', 'model_property' => 'lat' },
        { 'csv_column_name' => 'lon', 'model_property' => 'lon' }
      ]
    end

    it 'is valid if all required properties are present' do
      import_mapping = ImportMapping.new(
        name: 'Test Mapping',
        mapping: valid_mapping
      )
      expect(import_mapping).to be_valid
    end

    it 'is invalid without a name' do
      import_mapping = ImportMapping.new(name: nil, mapping: valid_mapping)
      expect(import_mapping).not_to be_valid
      expect(import_mapping.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a duplicate name' do
      ImportMapping.create!(name: 'Duplicate Name', mapping: valid_mapping)
      duplicate_mapping = ImportMapping.new(
        name: 'Duplicate Name',
        mapping: valid_mapping
      )
      expect(duplicate_mapping).not_to be_valid
      expect(duplicate_mapping.errors[:name]).to include('has already been taken')
    end

    it 'is invalid if required properties are missing' do
      import_mapping = ImportMapping.new(
        name: 'Test Mapping',
        mapping: [
          { 'csv_column_name' => 'title', 'model_property' => 'title' }
        ]
      )
      expect(import_mapping).not_to be_valid
      expect(import_mapping.errors[:mapping]).to include('is missing required properties: lat, lon')
    end

    it 'is invalid if mapping is empty' do
      import_mapping = ImportMapping.new(name: 'Test Mapping', mapping: [])
      expect(import_mapping).not_to be_valid
      expect(import_mapping.errors[:mapping]).to include('is missing required properties: title, lat, lon')
    end
  end

  describe '#unprocessable_fields' do
    let(:import_mapping) do
      ImportMapping.new(
        mapping: [
          { 'csv_column_name' => 'title', 'model_property' => 'title' },
          { 'csv_column_name' => 'lat', 'model_property' => 'lat' },
          { 'csv_column_name' => 'lon', 'model_property' => 'lon' }
        ]
      )
    end

    it 'returns headers that are not mapped' do
      header_row = %w[title lat lon extra_column]
      expect(import_mapping.unprocessable_fields(header_row)).to eq(['extra_column'])
    end

    it 'returns an empty array if all headers are mapped' do
      header_row = %w[title lat lon]
      expect(import_mapping.unprocessable_fields(header_row)).to eq([])
    end

    it 'returns an empty array if header row is empty' do
      header_row = []
      expect(import_mapping.unprocessable_fields(header_row)).to eq([])
    end
  end

  describe '.from_header' do
    it 'creates an ImportMapping with matching headers' do
      header_row = %w[title lat extra_column]
      import_mapping = ImportMapping.from_header(header_row)

      expect(import_mapping.mapping).to eq([
                                             { 'csv_column_name' => 'title', 'model_property' => 'title', 'parsers' => [], 'key' => false },
                                             { 'csv_column_name' => 'lat', 'model_property' => 'lat', 'parsers' => [], 'key' => false }
                                           ])
    end

    it 'returns an empty mapping if no headers match' do
      header_row = ['non_matching_column']
      import_mapping = ImportMapping.from_header(header_row)

      expect(import_mapping.mapping).to eq([])
    end

    it 'handles an empty header row' do
      header_row = []
      import_mapping = ImportMapping.from_header(header_row)

      expect(import_mapping.mapping).to eq([])
    end

    it 'ignores duplicate headers in the input' do
      header_row = %w[title title lat]
      import_mapping = ImportMapping.from_header(header_row)

      expect(import_mapping.mapping).to eq([
                                             { 'csv_column_name' => 'title', 'model_property' => 'title', 'parsers' => [], 'key' => false },
                                             { 'csv_column_name' => 'lat', 'model_property' => 'lat', 'parsers' => [], 'key' => false }
                                           ])
    end
  end
end
