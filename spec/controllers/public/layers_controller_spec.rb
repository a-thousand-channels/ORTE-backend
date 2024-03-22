# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::LayersController, type: :controller do
  render_views

  describe 'functionalities for everybody' do
    before do
      @group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: @group.id)
      @map = FactoryBot.create(:map, group_id: @group.id)
    end

    let(:map) do
      FactoryBot.create(:layer, map_id: @map.id)
    end

    let(:valid_attributes) do
      FactoryBot.build(:layer, map_id: @map.id, published: true).attributes
    end

    let(:invalid_attributes) do
      FactoryBot.build(:layer, map_id: @map.id, published: false).attributes
    end

    let(:valid_session) { {} }

    describe 'GET #show w/JSON format' do
      it 'returns a success response for a published layer' do
        layer = Layer.create! valid_attributes
        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns sorted results a published layer, sorted by ID' do
        layer = FactoryBot.create(:layer, map_id: @map.id, published: true)
        place1 = FactoryBot.create(:place, layer: layer, published: true, title: 'C')
        place2 = FactoryBot.create(:place, layer: layer, published: true, title: 'A')
        place3 = FactoryBot.create(:place, layer: layer, published: true, title: 'B')
        place4_notpublished = FactoryBot.create(:place, layer: layer, published: false)

        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'json' }, session: valid_session

        expect(assigns(:layer)).to eq(layer)
        expect(assigns(:places)).to eq([place1, place2, place3])
      end

      it 'returns sorted results a published layer, sorted by title' do
        layer = FactoryBot.create(:layer, :sorted_by_title, map_id: @map.id, published: true)
        place1 = FactoryBot.create(:place, layer: layer, published: true, title: 'C')
        place2 = FactoryBot.create(:place, layer: layer, published: true, title: 'A')
        place3 = FactoryBot.create(:place, layer: layer, published: true, title: 'B')
        place4_notpublished = FactoryBot.create(:place, layer: layer, published: false)

        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'json' }, session: valid_session

        expect(assigns(:layer)).to eq(layer)
        expect(assigns(:places)).to eq([place2, place3, place1])
      end

      it 'returns sorted results a published layer, sorted by startdate' do
        layer = FactoryBot.create(:layer, :sorted_by_startdate, map_id: @map.id, published: true)
        place1 = FactoryBot.create(:place, layer: layer, published: true, startdate_date: Time.now - 2.day)
        place2 = FactoryBot.create(:place, layer: layer, published: true, startdate_date: Time.now - 4.day)
        place3 = FactoryBot.create(:place, layer: layer, published: true, startdate_date: Time.now - 3.day)
        place4_notpublished = FactoryBot.create(:place, layer: layer, published: false)

        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'json' }, session: valid_session

        expect(assigns(:layer)).to eq(layer)
        expect(assigns(:places)).to eq([place2, place3, place1])
      end

      it 'returns json for a published layer' do
        layer = Layer.create! valid_attributes
        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns json with a valid scheme' do
        layer = FactoryBot.create(:layer, map_id: @map.id, published: true)
        place = FactoryBot.create(:place, layer_id: layer.id, published: true)
        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'json' }, session: valid_session
        expect(response).to match_response_schema('layer', 'json')
      end

      it 'returns an 403 + error response for unpublished resources' do
        layer = Layer.create! invalid_attributes
        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(403)
        expect(JSON.parse(response.body)['error']).to match(/Layer not accessible/)
      end
    end

    describe 'GET #show w/GeoJSON format' do
      it 'returns a success response for a published layer' do
        layer = Layer.create! valid_attributes
        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'geojson' }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns geojson for a published layer' do
        layer = Layer.create! valid_attributes
        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'geojson' }, session: valid_session
        expect(response).to have_http_status(200)
        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/geo+json; charset=utf-8')
      end

      it 'returns geojson with a valid scheme' do
        layer = FactoryBot.create(:layer, map_id: @map.id, published: true)
        place = FactoryBot.create(:place, layer_id: layer.id, published: true)
        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'geojson' }, session: valid_session
        expect(response).to match_response_schema('layer', 'geojson')
      end

      it 'returns an 403 + error response for unpublished resources' do
        layer = Layer.create! invalid_attributes
        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'geojson' }, session: valid_session
        expect(response).to have_http_status(403)
        expect(JSON.parse(response.body)['error']).to match(/Layer not accessible/)
      end
    end

    describe 'GET #show w/ZIP format' do
      it 'returns a success response for a published layer' do
        layer = Layer.create! valid_attributes
        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'zip' }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end
end
