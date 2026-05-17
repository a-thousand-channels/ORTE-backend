# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Imports::KmlImporter do
  describe '#import' do
    let(:file) { Rack::Test::UploadedFile.new('spec/support/files/places.kml', 'application/vnd.google-earth.kml+xml') }

    let(:layer) { create(:layer) }

    context 'with valid KML' do
      it 'returns valid rows' do
        importer = Imports::KmlImporter.new(file, layer.id)
        importer.import
        expect(importer.valid_rows.count).to eq(2)
      end

      it 'returns valid rows except duplicate rows' do
        place = create(:place, title: 'Place 1', layer: layer)
        importer = Imports::KmlImporter.new(file, layer.id)
        importer.import
        expect(importer.valid_rows.count).to eq(1)
        expect(importer.duplicate_rows.count).to eq(1)
      end
    end

    context 'with invalid KML' do
      it 'handles wrong kml file' do
        invalid_file = Rack::Test::UploadedFile.new('spec/support/files/places_invalid.kml', 'application/vnd.google-earth.kml+xml')

        importer = Imports::KmlImporter.new(invalid_file, layer.id)
        expect do
          importer.import
        end.to raise_error(StandardError)
      end
    end
  end
end
