# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Imports::CsvImporter do
  describe '#import' do
    let(:file) { Rack::Test::UploadedFile.new('spec/support/files/places.csv', 'text/csv') }

    let(:layer) { create(:layer) }

    context 'with valid CSV' do
      it 'returns valid rows', focus:true do
        importer = Imports::CsvImporter.new(file, layer.id)
        expect(importer.valid_rows.count).to eq(1)
      end
      
      it 'returns valid rows except non-allowed columns' do
        file = Rack::Test::UploadedFile.new('spec/support/files/places_valid_but_with_not_allowed_data.csv', 'text/csv')

        importer = Imports::CsvImporter.new(file, layer.id)
        expect(importer.unprocessable_fields).to contain_exactly('id', 'annotations', 'unknown')
        expect(importer.valid_rows).to contain_exactly('id', 'annotations')
      end

      it 'sanitizes a title with js and html' do
        file_with_html = Rack::Test::UploadedFile.new('spec/support/files/places_with_html.csv', 'text/csv')

        importer = Imports::CsvImporter.new(file_with_html, layer.id)
        puts importer.valid_rows.inspect
        expect(importer.valid_rows.count).to eq(1)
        expect(importer.valid_rows.first.teaser).to eq('Ein etwas versteckt gelegenes Fleckchen')
      end
    end

    context 'with invalid CSV' do
      it 'handles empty rows and does not create Place records' do
        invalid_file = Rack::Test::UploadedFile.new('spec/support/files/places_nodata.csv', 'text/csv')

        importer = Imports::CsvImporter.new(invalid_file, layer.id)
        expect(importer.invalid_rows.count).to eq(1)
      end

      it 'handles wrong csv header and does not create Place records' do
        invalid_file = Rack::Test::UploadedFile.new('spec/support/files/places_invalid_header.csv', 'text/csv')

        importer = Imports::CsvImporter.new(invalid_file, layer.id)

        expect do
          importer.import
        end.to raise_error(StandardError)
      end

      it 'handles invalid row with wrong lat value and does not create Place records' do
        invalid_file = Rack::Test::UploadedFile.new('spec/support/files/places_invalid_lat.csv', 'text/csv')

        importer = Imports::CsvImporter.new(invalid_file, layer.id)
        expect(importer.invalid_rows.count).to eq(2)
      end
    end
  end
end
