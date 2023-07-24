# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Imports::CsvImporter do
  describe '#import' do
    let(:file) { Rack::Test::UploadedFile.new('spec/support/files/places.csv', 'text/csv') }

    let(:layer) { create(:layer) }

    context 'with valid CSV' do
      it 'creates new Place records from valid rows' do
        importer = Imports::CsvImporter.new(file, layer.id)

        expect do
          importer.import
        end.to change(Place, :count).by(2)

        expect(Place.pluck(:title)).to contain_exactly('Place 1', 'Place 2')
      end
      it 'creates new Place records from valid rows except non-allowed columns' do
        file = Rack::Test::UploadedFile.new('spec/support/files/places_valid_but_with_not_allowed_data.csv', 'text/csv')

        importer = Imports::CsvImporter.new(file, layer.id)

        expect do
          importer.import
        end.to change(Place, :count).by(2)

        expect(importer.unprocessable_fields).to contain_exactly('id', 'annotations', 'unknown')

        # TODO: test outcome
      end
    end

    context 'with invalid CSV' do
      it 'handles empty rows and does not create Place records' do
        invalid_file = Rack::Test::UploadedFile.new('spec/support/files/places_nodata.csv', 'text/csv')

        importer = Imports::CsvImporter.new(invalid_file, layer.id)

        expect do
          importer.import
        end.not_to change(Place, :count)

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

        expect do
          importer.import
        end.not_to change(Place, :count)

        expect(importer.invalid_rows.count).to eq(1)
      end

      it 'sanitizes a title with js and html' do
        file_with_html = Rack::Test::UploadedFile.new('spec/support/files/places_with_html.csv', 'text/csv')

        importer = Imports::CsvImporter.new(file_with_html, layer.id)

        expect do
          importer.import
        end.to change(Place, :count).by(1)

        expect(Place.first.teaser).to eq('Ein etwas versteckt gelegenes Fleckchen')
      end
    end
  end
end
