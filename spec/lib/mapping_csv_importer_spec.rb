# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Imports::MappingCsvImporter do
  describe '#import' do
    let(:file) { Rack::Test::UploadedFile.new('spec/support/files/places.csv', 'text/csv') }

    let(:layer) { create(:layer) }
    let(:import_mapping) { create(:import_mapping) }

    context 'with valid CSV' do
      it 'returns valid rows' do
        importer = Imports::MappingCsvImporter.new(file, layer.id, import_mapping)
        importer.import
        expect(importer.valid_rows.count).to eq(2)
      end

      it 'returns valid rows except non-allowed columns' do
        file = Rack::Test::UploadedFile.new('spec/support/files/places_valid_but_with_not_allowed_data.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file, layer.id, import_mapping)
        importer.import
        #expect(importer.unprocessable_fields).to contain_exactly('id', 'annotations', 'unknown')
        expect(importer.valid_rows.count).to eq(2)
        #expect(importer.valid_rows.first['teaser']).to match('Ein etwas versteckt gelegenes und ')
      end

      it 'returns valid rows except duplicate and invalid rows' do
        place = create(:place, title: 'title1', layer: layer)
        file = Rack::Test::UploadedFile.new('spec/support/files/places_invalid_lat.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file, layer.id, import_mapping)
        importer.import
        # expect(importer.valid_rows.count).to eq(0)
        # expect(importer.duplicate_rows.count).to eq(1)
        expect(importer.invalid_rows.count).to eq(2)
      end

      it 'sanitizes a title with js and html' do
        file_with_html = Rack::Test::UploadedFile.new('spec/support/files/places_with_html.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file_with_html, layer.id, import_mapping)
        importer.import
        expect(importer.valid_rows.count).to eq(1)
        #expect(importer.valid_rows.first['teaser']).to match('Ein etwas <em>versteckt</em> gelegenes')
      end
    end

    context 'with invalid CSV' do
      it 'handles empty rows and does not create Place records' do
        invalid_file = Rack::Test::UploadedFile.new('spec/support/files/places_nodata.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(invalid_file, layer.id, import_mapping)
        importer.import
        expect(importer.invalid_rows.count).to eq(1)
      end

      it 'handles wrong csv header and does not create Place records' do
        invalid_file = Rack::Test::UploadedFile.new('spec/support/files/places_invalid_header.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(invalid_file, layer.id, import_mapping)
        expect do
          importer.import
        end.to raise_error(StandardError)
      end

      it 'handles invalid row with wrong lat value and does not create Place records' do
        invalid_file = Rack::Test::UploadedFile.new('spec/support/files/places_invalid_lat.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(invalid_file, layer.id, import_mapping)
        importer.import
        expect(importer.invalid_rows.count).to eq(2)
      end
    end

    context 'with semicolon-separated CSV' do
      it 'returns valid rows' do
        file = Rack::Test::UploadedFile.new('spec/support/files/places_with_semicolon_separator.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file, layer.id, import_mapping, col_sep: ';')
        importer.import
        expect(importer.valid_rows.count).to eq(2)
      end
    end

    context 'with tab-separated CSV' do
      it 'returns valid rows' do
        file = Rack::Test::UploadedFile.new('spec/support/files/places_with_tab_separator.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file, layer.id, import_mapping, col_sep: "\t", quote_char: "'")
        importer.import
        expect(importer.valid_rows.count).to eq(2)
      end
      # Todo: test with tab-separated CSV will einfach nicht funktionieren
    end

    #todo: weitere Testfälle erstellen mit mapping

    context 'with not matching mapping' do
      it 'detects unmatching of mapping and does not create Place records' do
        not_matching_mapping = create(:import_mapping)
        file_invalid_headers = Rack::Test::UploadedFile.new('spec/support/files/places_invalid_header_valid_rows.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file_invalid_headers, layer.id, not_matching_mapping)
        # expect do
        #   importer.import
        # end.to raise_error(StandardError)
        # Todo: error werfen, dass mapping nicht passt?!
        importer.import
        expect(importer.valid_rows.count).to eq(0)
      end
    end

    context 'with matching mapping' do
      it 'uses the mapping and successfully creates Place records' do
        matching_mapping = create(:import_mapping, mapping: [
                                    { csv_column_name: 'titleX', model_property: 'title' },
                                    { csv_column_name: 'latX', model_property: 'lat' },
                                    { csv_column_name: 'lonX', model_property: 'lon' }
                                  ])
        file_invalid_headers = Rack::Test::UploadedFile.new('spec/support/files/places_invalid_header_valid_rows.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file_invalid_headers, layer.id, matching_mapping)
        expect do
          importer.import
        end.not_to raise_error
        expect(importer.valid_rows.count).to eq(1)
      end
    end

    context 'with valid mapping and parsing' do
      it 'parses the tags correctly' do
        mapping = create(:import_mapping, mapping: [
                           { csv_column_name: 'title', model_property: 'title', parsers: ['trim'] },
                           { csv_column_name: 'lat', model_property: 'lat', parsers: [] },
                           { csv_column_name: 'lon', model_property: 'lon', parsers: [] },
                           { csv_column_name: 'tags', model_property: 'tags', parsers: %w[remove_leading_hash spaces_to_commas] }
                         ])
        file_to_be_parsed = Rack::Test::UploadedFile.new('spec/support/files/places_to_be_parsed.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file_to_be_parsed, layer.id, mapping)
        expect do
          importer.import
        end.not_to raise_error
        expect(importer.valid_rows.count).to eq(1)
        expect(importer.valid_rows.last.title).to eq('Place to be')
        expect(importer.valid_rows.last.tag_list).to eq(%w[gay club party])
      end

      it 'parses lat and lon from one into into two different fields' do
        mapping = create(:import_mapping, mapping: [
                           { csv_column_name: 'title', model_property: 'title' },
                           { csv_column_name: 'coords', model_property: 'lat', parsers: ['split_to_first'] },
                           { csv_column_name: 'coords', model_property: 'lon', parsers: ['split_to_last'] }
                         ])
        file_to_be_parsed = Rack::Test::UploadedFile.new('spec/support/files/places_lat_lon.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file_to_be_parsed, layer.id, mapping, col_sep: ';')
        expect do
          importer.import
        end.not_to raise_error
        expect(importer.valid_rows.count).to eq(2)
        expect(importer.valid_rows.last.lat).to eq('53.55')
        expect(importer.valid_rows.last.lon).to eq('9.95')
      end

      it 'parses lon and lat from one into into two different fields' do
        mapping = create(:import_mapping, mapping: [
                           { csv_column_name: 'title', model_property: 'title' },
                           { csv_column_name: 'coords', model_property: 'lat', parsers: ['split_to_last'] },
                           { csv_column_name: 'coords', model_property: 'lon', parsers: ['split_to_first'] }
                         ])
        file_to_be_parsed = Rack::Test::UploadedFile.new('spec/support/files/places_lon_lat.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file_to_be_parsed, layer.id, mapping, col_sep: ';')
        expect do
          importer.import
        end.not_to raise_error
        expect(importer.valid_rows.count).to eq(2)
        expect(importer.valid_rows.last.lat).to eq('53.55')
        expect(importer.valid_rows.last.lon).to eq('9.95')
      end

      it 'parses european dates into datetime format' do
        mapping = create(:import_mapping, mapping: [
                           { csv_column_name: 'title', model_property: 'title'},
                           { csv_column_name: 'lon', model_property: 'lon' },
                           { csv_column_name: 'lat', model_property: 'lat' },
                           { csv_column_name: 'starting_from', model_property: 'startdate', parsers: ['european_date'] },
                           { csv_column_name: 'ending_from', model_property: 'enddate', parsers: ['european_date'] }
                         ])
        file_to_be_parsed = Rack::Test::UploadedFile.new('spec/support/files/places_european_date.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file_to_be_parsed, layer.id, mapping)
        expect do
          importer.import
        end.not_to raise_error
        expect(importer.valid_rows.count).to eq(2)
        expect(importer.valid_rows.last.startdate).to eq('2022-02-25 00:00:00 UTC')
        expect(importer.valid_rows.last.enddate).to eq('2024-02-20 00:00:00 UTC')
      end

      it 'parses american dates into datetime format' do
        mapping = create(:import_mapping, mapping: [
          { csv_column_name: 'title', model_property: 'title'},
          { csv_column_name: 'lon', model_property: 'lon' },
          { csv_column_name: 'lat', model_property: 'lat' },
          { csv_column_name: 'starting_from', model_property: 'startdate', parsers: ['american_date'] },
          { csv_column_name: 'ending_from', model_property: 'enddate', parsers: ['american_date'] }
        ])
        file_to_be_parsed = Rack::Test::UploadedFile.new('spec/support/files/places_american_date.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file_to_be_parsed, layer.id, mapping)
        expect do
          importer.import
        end.not_to raise_error
        expect(importer.valid_rows.count).to eq(2)
        expect(importer.valid_rows.last.startdate).to eq('2020-06-30 00:00:00 UTC')
        expect(importer.valid_rows.last.enddate).to eq('2024-09-10 00:00:00 UTC')
      end
    end
  end
end
