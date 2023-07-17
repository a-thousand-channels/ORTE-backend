# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Imports::CsvImporter do
  describe '#import' do
    let(:file) { Rack::Test::UploadedFile.new('spec/support/files/places.csv', 'text/csv') }

    let(:layer) { create(:layer) }

    context 'with valid CSV' do
      it 'creates new Place records from valid rows' do
        importer = Imports::CsvImporter.new(file,layer.id)

        expect {
          importer.import
        }.to change(Place, :count).by(3) # Assuming the CSV file has 3 valid rows

        # Additional assertions if needed
        expect(Place.pluck(:title)).to contain_exactly('Place 1', 'Place 2', 'Place 3')
      end
    end

    context 'with invalid CSV' do
      it 'handles invalid rows and does not create Place records' do
        invalid_file = Rack::Test::UploadedFile.new('spec/support/files/places_invalid.csv', 'text/csv')

        importer = Imports::CsvImporter.new(invalid_file,layer.id)

        expect {
          importer.import
        }.not_to change(Place, :count)

        expect(importer.invalid_rows.count).to eq(1)
      end
    end
  end
end
