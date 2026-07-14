# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Public Places API - Translations', type: :request do
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

  describe 'GET /public/maps/:map_id/layers/:layer_id/places/:id.json' do
    context 'when place is published' do
      it 'returns the published place as JSON with default fields' do
        get public_map_layer_place_path(map, layer, place), params: { format: :json }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')

        json_response = JSON.parse(response.body)
        expect(json_response['place']).to be_present
        expect(json_response['place']['id']).to eq(place.id)
        # Public API returns default fields
        expect(json_response['place']['title']).to eq('Deutscher Titel')
        expect(json_response['place']['subtitle']).to eq('Deutscher Untertitel')
      end

      it 'exposes all available translations via localized_versions' do
        get public_map_layer_place_path(map, layer, place), params: { format: :json }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        place_data = json_response['place']

        expect(place_data['localized_versions']).to be_present
        expect(place_data['localized_versions']).to be_a(Hash)

        # Check that all available locales are present as keys
        locales = place_data['localized_versions'].keys
        expect(locales).to include('de', 'en', 'fr', 'ru', 'it', 'pl', 'nl')

        # Check German (primary language) translations
        expect(place_data['localized_versions']['de']['title']).to eq('Deutscher Titel')
        expect(place_data['localized_versions']['de']['subtitle']).to eq('Deutscher Untertitel')
        expect(place_data['localized_versions']['de']['teaser']).to eq('Deutscher Teaser')
        expect(place_data['localized_versions']['de']['text']).to eq('Deutscher Text')
        expect(place_data['localized_versions']['de']['sources']).to eq('Deutsche Quellen')

        # Check English translations
        expect(place_data['localized_versions']['en']['title']).to eq('English Title')
        expect(place_data['localized_versions']['en']['subtitle']).to eq('English Subtitle')
        expect(place_data['localized_versions']['en']['teaser']).to eq('English Teaser')
        expect(place_data['localized_versions']['en']['text']).to eq('English Text')
        expect(place_data['localized_versions']['en']['sources']).to eq('English Sources')

        # Check French translations
        expect(place_data['localized_versions']['fr']['title']).to eq('Titre Français')
        expect(place_data['localized_versions']['fr']['subtitle']).to eq('Sous-titre Français')
        expect(place_data['localized_versions']['fr']['teaser']).to eq('Teaser Français')
        expect(place_data['localized_versions']['fr']['text']).to eq('Texte Français')
        expect(place_data['localized_versions']['fr']['sources']).to eq('Sources Françaises')

        # Check untranslated locale (should fall back to defaults)
        expect(place_data['localized_versions']['ru']['title']).to eq('Deutscher Titel')
        expect(place_data['localized_versions']['ru']['subtitle']).to eq('Deutscher Untertitel')
      end
    end

    context 'when place is not published' do
      before { place.update(published: false) }

      it 'returns forbidden error' do
        get public_map_layer_place_path(map, layer, place), params: { format: :json }

        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to be_present
      end
    end
  end

  describe 'GET /public/maps/:map_id/allplaces.json' do
    context 'when requesting all places for a map' do
      it 'returns published places as JSON with default fields' do
        get "/public/maps/#{map.id}/allplaces.json"

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        # allplaces response structure is { "map": { "places": [...] } }
        places_data = json_response['map']['places']
        expect(places_data).to be_an(Array)
        expect(places_data.count).to be >= 1

        # Find our test place in the response
        test_place = places_data.find { |p| p['id'] == place.id }
        expect(test_place).to be_present
        # Public API returns default fields
        expect(test_place['title']).to eq('Deutscher Titel')
      end

      it 'includes localized_versions for all places' do
        get "/public/maps/#{map.id}/allplaces.json"

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        places_data = json_response['map']['places']
        test_place = places_data.find { |p| p['id'] == place.id }
        expect(test_place).to be_present

        # Verify localized_versions is present
        expect(test_place['localized_versions']).to be_present
        expect(test_place['localized_versions']).to be_a(Hash)

        # Check German translations
        expect(test_place['localized_versions']['de']['title']).to eq('Deutscher Titel')
        # Check English translations
        expect(test_place['localized_versions']['en']['title']).to eq('English Title')
        # Check French translations
        expect(test_place['localized_versions']['fr']['title']).to eq('Titre Français')
      end
    end
  end
end
