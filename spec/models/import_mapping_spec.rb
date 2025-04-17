# spec/models/import_mapping_spec.rb
require 'rails_helper'

RSpec.describe ImportMapping, type: :model do
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
      header_row = ['title', 'lat', 'lon', 'extra_column']
      expect(import_mapping.unprocessable_fields(header_row)).to eq(['extra_column'])
    end

    it 'returns an empty array if all headers are mapped' do
      header_row = ['title', 'lat', 'lon']
      expect(import_mapping.unprocessable_fields(header_row)).to eq([])
    end

    it 'returns an empty array if header row is empty' do
      header_row = []
      expect(import_mapping.unprocessable_fields(header_row)).to eq([])
    end
  end

  describe '.from_header' do
    it 'creates an ImportMapping with matching headers' do
      header_row = ['title', 'lat', 'extra_column']
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
      header_row = ['title', 'title', 'lat']
      import_mapping = ImportMapping.from_header(header_row)

      expect(import_mapping.mapping).to eq([
                                             { 'csv_column_name' => 'title', 'model_property' => 'title', 'parsers' => [], 'key' => false },
                                             { 'csv_column_name' => 'lat', 'model_property' => 'lat', 'parsers' => [], 'key' => false }
                                           ])
    end
  end
end
