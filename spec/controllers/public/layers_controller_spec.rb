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

      it 'returns only accordingly tagged places when filtered by tag' do
        layer = Layer.create! valid_attributes
        place1 = FactoryBot.create(:place, layer: layer, published: true, tag_list: %w[aaa bbb ccc])
        place2 = FactoryBot.create(:place, layer: layer, published: true, tag_list: %w[ddd eee])
        place3 = FactoryBot.create(:place, layer: layer, published: true, tag_list: %w[fff])

        get :show, params: { id: layer.to_param, map_id: @map.id, filter_by_tags: 'bbb,fff', format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
        expect(assigns(:places)).to eq([place1, place3])
        expect(assigns(:places)).not_to include(place2)
      end

      it 'can handle images with and without sorting values' do
        layer = FactoryBot.create(:layer, map_id: @map.id, published: true)
        place = FactoryBot.create(:place, layer_id: layer.id, published: true)
        FactoryBot.create(:image, place: place, sorting: nil)
        FactoryBot.create(:image, place: place, sorting: 1)
        get :show, params: { id: layer.to_param, map_id: @map.id, format: 'json' }, session: valid_session
        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
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

    describe 'preventing n+1 queries for GET #show w/JSON and w/GeoJSON format' do
      before do
        @map = FactoryBot.create(:map, published: true)
        @layer = FactoryBot.create(:layer, map_id: @map.id, published: true)
        # Create 6 places with relations between them
        3.times do
          place1 = FactoryBot.create(:place, :with_audio, layer_id: @layer.id, tag_list: %w[aaa bbb ccc], published: true)
          place2 = FactoryBot.create(:place, layer_id: @layer.id, tag_list: %w[bbb ccc ddd], published: true)
          FactoryBot.create(:relation, relation_from: place1, relation_to: place2)
        end
      end

      def trigger_show_json
        get :show, params: { id: @layer.to_param, map_id: @map.id, format: 'json' }, session: valid_session
      end

      def trigger_show_geomap
        get :show, params: { id: @layer.to_param, map_id: @map.id, format: 'geojson' }, session: valid_session
      end

      it 'makes the same number of queries, no matter how many records are delivered' do
        # Measure queries before adding additional records
        x_json = count_queries { trigger_show_json }
        x_geo = count_queries { trigger_show_geomap }

        # Create 3 additional places with relations between them
        3.times do
          place1 = FactoryBot.create(:place, :with_audio, layer_id: @layer.id, tag_list: %w[aaa bbb ccc], published: true)
          place2 = FactoryBot.create(:place, layer_id: @layer.id, tag_list: %w[bbb ccc ddd], published: true)
          FactoryBot.create(:relation, relation_from: place1, relation_to: place2)
        end

        # Measure queries after adding records
        y_json = count_queries { trigger_show_json }
        y_geo = count_queries { trigger_show_geomap }

        # Ensure query count remains the same
        expect(x_json).to eq(y_json)
        expect(x_geo).to eq(y_geo)
      end
    end
  end
end
