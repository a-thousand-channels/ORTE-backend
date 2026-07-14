# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Public Maps API - Translations', type: :request do
  let(:map) { create(:map, primary_language: 'de', published: true) }
  let(:layer) { create(:layer, map: map, published: true) }
  let(:place) do
    create(:place,
           layer: layer,
           published: true,
           title: 'Deutscher Titel',
           subtitle: 'Deutscher Untertitel',
           teaser: 'Deutscher Teaser',
           text: 'Deutscher Text',
           sources: 'Deutsche Quellen')
  end

  before do
    # Set up translations for different locales
    Mobility.with_locale(:en) do
      place.update(
        localized_title: 'English Title',
        localized_subtitle: 'English Subtitle',
        localized_teaser: 'English Teaser',
        localized_text: 'English Text',
        localized_sources: 'English Sources'
      )
    end

    Mobility.with_locale(:fr) do
      place.update(
        localized_title: 'Titre Français',
        localized_subtitle: 'Sous-titre Français',
        localized_teaser: 'Teaser Français',
        localized_text: 'Texte Français',
        localized_sources: 'Sources Françaises'
      )
    end
  end

  describe 'GET /public/maps/:id.json' do
    context 'when map is published' do
      it 'returns the published map as JSON' do
        get public_map_path(map), params: { format: :json }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')

        json_response = JSON.parse(response.body)
        expect(json_response['map']).to be_present
        expect(json_response['map']['id']).to eq(map.id)
      end

      it 'includes places with localized_versions in the response' do
        get public_map_path(map), params: { format: :json }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        map_data = json_response['map']

        # Check that layer is present (note: it's 'layer' not 'layers')
        expect(map_data['layer']).to be_an(Array)
        expect(map_data['layer'].count).to be >= 1

        # Find our test layer
        test_layer = map_data['layer'].find { |l| l['id'] == layer.id }
        expect(test_layer).to be_present

        # Check that places are present
        places = test_layer['places']
        expect(places).to be_an(Array)
        expect(places.count).to be >= 1

        # Find our test place
        test_place = places.find { |p| p['id'] == place.id }
        expect(test_place).to be_present

        # Verify localized_versions is present
        expect(test_place['localized_versions']).to be_present
        expect(test_place['localized_versions']).to be_a(Hash)

        # Check that all available locales are present as keys
        locales = test_place['localized_versions'].keys
        expect(locales).to include('de', 'en', 'fr', 'ru', 'it', 'pl', 'nl')

        # Check German (primary language) translations
        expect(test_place['localized_versions']['de']['title']).to eq('Deutscher Titel')
        expect(test_place['localized_versions']['de']['subtitle']).to eq('Deutscher Untertitel')
        expect(test_place['localized_versions']['de']['teaser']).to eq('Deutscher Teaser')

        # Check English translations
        expect(test_place['localized_versions']['en']['title']).to eq('English Title')
        expect(test_place['localized_versions']['en']['subtitle']).to eq('English Subtitle')
        expect(test_place['localized_versions']['en']['teaser']).to eq('English Teaser')

        # Check French translations
        expect(test_place['localized_versions']['fr']['title']).to eq('Titre Français')
        expect(test_place['localized_versions']['fr']['subtitle']).to eq('Sous-titre Français')
        expect(test_place['localized_versions']['fr']['teaser']).to eq('Teaser Français')

        # Check untranslated locale (should fall back to defaults)
        expect(test_place['localized_versions']['ru']['title']).to eq('Deutscher Titel')
      end
    end

    context 'when map is not published' do
      before { map.update(published: false) }

      it 'returns forbidden error' do
        get public_map_path(map), params: { format: :json }

        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to be_present
      end
    end
  end

  describe 'GET /public/maps/:id/layers/:layer_id.json' do
    context 'when layer is published' do
      it 'returns the published layer as JSON with places and localized_versions' do
        get public_map_layer_path(map, layer), params: { format: :json }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        layer_data = json_response['layer']

        expect(layer_data).to be_present
        expect(layer_data['id']).to eq(layer.id)

        # Check places
        places = layer_data['places']
        expect(places).to be_an(Array)
        expect(places.count).to be >= 1

        # Find our test place
        test_place = places.find { |p| p['id'] == place.id }
        expect(test_place).to be_present

        # Verify localized_versions is present
        expect(test_place['localized_versions']).to be_present
        expect(test_place['localized_versions']).to be_a(Hash)

        # Check that all available locales are present
        locales = test_place['localized_versions'].keys
        expect(locales).to include('de', 'en', 'fr', 'ru', 'it', 'pl', 'nl')

        # Check various locale versions
        expect(test_place['localized_versions']['de']['title']).to eq('Deutscher Titel')
        expect(test_place['localized_versions']['en']['title']).to eq('English Title')
        expect(test_place['localized_versions']['fr']['title']).to eq('Titre Français')
      end
    end

    context 'when layer is not published' do
      before { layer.update(published: false) }

      it 'returns forbidden error' do
        get public_map_layer_path(map, layer), params: { format: :json }

        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to be_present
      end
    end
  end
end
