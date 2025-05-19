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
        expect(importer.valid_rows.count).to eq(2)
        expect(importer.valid_rows.first['teaser']).to match('Ein etwas versteckt gelegenes und ')
      end

      it 'returns valid rows except duplicate and invalid rows' do
        create(:place, title: 'title1', layer: layer)
        file = Rack::Test::UploadedFile.new('spec/support/files/places_invalid_lat.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file, layer.id, import_mapping)
        importer.import
        expect(importer.valid_rows.count).to eq(0)
        expect(importer.duplicate_rows.count).to eq(1)
        expect(importer.errored_rows.count).to eq(2)
        expect(importer.ambiguous_rows.count).to eq(0)
      end

      it 'sanitizes a title with js by removing script tags' do
        file_with_html = Rack::Test::UploadedFile.new('spec/support/files/places_with_html.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file_with_html, layer.id, import_mapping)
        importer.import
        expect(importer.valid_rows.count).to eq(1)
        expect(importer.valid_rows.first['teaser']).to match("Ein etwas <em>versteckt</em> gelegenes <a href=\"#\">Fleckchen</a> let s ='a string'")
      end
    end

    context 'with invalid CSV' do
      it 'handles empty rows and does not create Place records' do
        invalid_file = Rack::Test::UploadedFile.new('spec/support/files/places_nodata.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(invalid_file, layer.id, import_mapping)
        importer.import
        expect(importer.errored_rows.count).to eq(1)
      end

      it 'handles wrong csv header and does not create Place records' do
        pending('error handling changed, test needs to be adjusted')
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
        expect(importer.errored_rows.count).to eq(2)
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

        importer = Imports::MappingCsvImporter.new(file, layer.id, import_mapping, col_sep: "\t")
        importer.import
        expect(importer.valid_rows.count).to eq(1)
        expect(importer.valid_rows.first.title).to eq('Place with tab separator')
      end
    end

    context 'when a single duplicate is found in the database' do
      it 'assigns duplicate_rows' do
        mapping = create(:import_mapping)
        file = Rack::Test::UploadedFile.new('spec/support/files/places.csv', 'text/csv')

        # Create 1 existing records with the same title as one place in the file
        existing_place = create(:place, title: 'Place 1', teaser: 'some text', layer: layer)

        importer = Imports::MappingCsvImporter.new(file, layer.id, mapping)
        importer.import

        expect(importer.duplicate_rows.count).to eq(1)
        expect(importer.duplicate_rows.first[:duplicate_id]).to eq(existing_place.id)
        expect(importer.ambiguous_rows.count).to eq(0)
      end
    end

    context 'when multiple duplicates are found in the database' do
      it 'assigns ambiguous_rows' do
        # Create mapping with title as key
        mapping = create(:import_mapping) # title is the key
        file = Rack::Test::UploadedFile.new('spec/support/files/places.csv', 'text/csv')

        # Create 2 existing records with the same title as one place in the file
        create(:place, title: 'Place 1', teaser: 'some text', layer: layer)
        create(:place, title: 'Place 1', teaser: 'some different text', layer: layer)

        importer = Imports::MappingCsvImporter.new(file, layer.id, mapping)
        importer.import

        expect(importer.ambiguous_rows.count).to eq(1)
        expect(importer.ambiguous_rows.first[:duplicate_count]).to eq(2)
        expect(importer.duplicate_rows.count).to eq(0)
      end
    end

    context 'with not matching mapping' do
      it 'does not build place records' do
        not_matching_mapping = create(:import_mapping)
        file_invalid_headers = Rack::Test::UploadedFile.new('spec/support/files/places_invalid_header_valid_rows.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file_invalid_headers, layer.id, not_matching_mapping)
        importer.import
        expect(importer.valid_rows.count).to eq(0)
      end
    end

    context 'with matching mapping' do
      it 'uses the mapping and successfully builds place records' do
        matching_mapping = create(:import_mapping, mapping: [
                                    { csv_column_name: 'titleX', model_property: 'title' },
                                    { csv_column_name: 'latX', model_property: 'lat' },
                                    { csv_column_name: 'lonX', model_property: 'lon' }
                                  ])
        file_invalid_headers = Rack::Test::UploadedFile.new('spec/support/files/places_invalid_header_valid_rows.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file_invalid_headers, layer.id, matching_mapping)
        importer.import
        expect(importer.valid_rows.count).to eq(1)
      end
    end

    context 'with valid mapping and parsing' do
      it 'parses the tags correctly' do
        mapping = create(:import_mapping, mapping: [
                           { csv_column_name: 'title', model_property: 'title', parsers: '["trim"]' },
                           { csv_column_name: 'lat', model_property: 'lat', parsers: '[]' },
                           { csv_column_name: 'lon', model_property: 'lon', parsers: '[]' },
                           { csv_column_name: 'tags', model_property: 'tag_list', parsers: '["remove_leading_hash", "spaces_to_commas"]' }
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
                           { csv_column_name: 'coords', model_property: 'lat', parsers: '["split_to_first"]' },
                           { csv_column_name: 'coords', model_property: 'lon', parsers: '["split_to_last"]' }
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
                           { csv_column_name: 'coords', model_property: 'lat', parsers: '["split_to_last"]' },
                           { csv_column_name: 'coords', model_property: 'lon', parsers: '["split_to_first"]' }
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
                           { csv_column_name: 'title', model_property: 'title' },
                           { csv_column_name: 'lon', model_property: 'lon' },
                           { csv_column_name: 'lat', model_property: 'lat' },
                           { csv_column_name: 'starting_from', model_property: 'startdate', parsers: '["european_date"]' },
                           { csv_column_name: 'ending_from', model_property: 'enddate', parsers: '["european_date"]' }
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
                           { csv_column_name: 'title', model_property: 'title' },
                           { csv_column_name: 'lon', model_property: 'lon' },
                           { csv_column_name: 'lat', model_property: 'lat' },
                           { csv_column_name: 'starting_from', model_property: 'startdate', parsers: '["american_date"]' },
                           { csv_column_name: 'ending_from', model_property: 'enddate', parsers: '["american_date"]' }
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

      it 'strips HTML tags from the title' do
        mapping = create(:import_mapping, mapping: [
                           { csv_column_name: 'title', model_property: 'title' },
                           { csv_column_name: 'teaser', model_property: 'teaser', parsers: '["strip_html_tags"]' },
                           { csv_column_name: 'lat', model_property: 'lat' },
                           { csv_column_name: 'lon', model_property: 'lon' }
                         ])
        file_with_html = Rack::Test::UploadedFile.new('spec/support/files/places_with_html.csv', 'text/csv')

        importer = Imports::MappingCsvImporter.new(file_with_html, layer.id, mapping)
        expect do
          importer.import
        end.not_to raise_error
        expect(importer.valid_rows.count).to eq(1)
        expect(importer.valid_rows.last.teaser).to eq("Ein etwas versteckt gelegenes Fleckchen let s ='a string'")
      end
    end
  end
end
