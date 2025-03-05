# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::MapsController, type: :controller do
  render_views

  describe 'functionalities with anonymous access' do
    before do
      @group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: @group.id)
    end

    let(:map) do
      FactoryBot.create(:map, group_id: @group.id)
    end

    let(:valid_attributes) do
      FactoryBot.build(:map, group_id: @group.id, published: true).attributes
    end

    let(:invalid_attributes) do
      FactoryBot.build(:map, group_id: @group.id, published: false).attributes
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a 403' do
        map = Map.create! valid_attributes
        get :index, params: { format: 'json' }, session: valid_session
        expect(response).to have_http_status(403)
      end
    end

    describe 'GET #show' do
      it 'returns a success response for a published map' do
        map = Map.create! valid_attributes
        get :show, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns json for a published map' do
        map = Map.create! valid_attributes
        get :show, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns json with a valid scheme' do
        map = Map.create! valid_attributes
        layer = FactoryBot.create(:layer, map_id: map.id, published: true)
        place = FactoryBot.create(:place, layer_id: layer.id, published: true)
        get :show, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to match_response_schema('map', 'json')
      end

      it 'returns an 403 + error response for unpublished resources' do
        map = Map.create! invalid_attributes
        get :show, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(403)
        expect(JSON.parse(response.body)['error']).to match(/Map not accessible/)
      end

      it 'returns all places when not filtered by tag' do
        map = Map.create! valid_attributes
        layer = FactoryBot.create(:layer, map_id: map.id, published: true)
        FactoryBot.create(:place, layer: layer, published: true, tag_list: %w[aaa bbb ccc])
        FactoryBot.create(:place, layer: layer, published: true, tag_list: %w[ddd eee])
        FactoryBot.create(:place, layer: layer, published: true, tag_list: %w[fff])

        get :show, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['map']['layer'][0]['places'].length).to eq 3
      end

      it 'returns only accordingly tagged places when filtered by tag' do
        map = Map.create! valid_attributes
        layer = FactoryBot.create(:layer, map_id: map.id, published: true)
        place1 = FactoryBot.create(:place, layer: layer, published: true, tag_list: %w[aaa bbb ccc])
        place2 = FactoryBot.create(:place, layer: layer, published: true, tag_list: %w[ddd eee])
        place3 = FactoryBot.create(:place, layer: layer, published: true, tag_list: %w[fff])

        get :show, params: { id: map.friendly_id, filter_by_tags: 'bbb,fff', format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['map']['layer'][0]['places'][0]['title']).to eq place1.title
        expect(json['map']['layer'][0]['places'][0]['tags']).to eq %w[aaa bbb ccc]
        expect(json['map']['layer'][0]['places'].length).to eq 2
      end

      it 'can handle images with and without sorting values' do
        map = Map.create! valid_attributes
        layer = FactoryBot.create(:layer, map_id: map.id, published: true)
        place = FactoryBot.create(:place, layer_id: layer.id, published: true)
        FactoryBot.create(:image, place: place, sorting: nil)
        FactoryBot.create(:image, place: place, sorting: 1)
        get :show, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    describe 'GET #allplaces' do
      it 'returns a success response for a published map' do
        map = Map.create! valid_attributes
        layer = FactoryBot.create(:layer, map_id: map.id, published: true)
        place = FactoryBot.create(:place, layer_id: layer.id, published: true)
        get :allplaces, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns json for a published map' do
        map = Map.create! valid_attributes
        layer = FactoryBot.create(:layer, map_id: map.id, published: true)
        place = FactoryBot.create(:place, layer_id: layer.id, published: true)
        get :allplaces, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns json with a valid scheme' do
        map = Map.create! valid_attributes
        layer = FactoryBot.create(:layer, map_id: map.id, published: true)
        place = FactoryBot.create(:place, layer_id: layer.id, published: true)
        get :allplaces, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to match_response_schema('map_allplaces', 'json')
      end

      it 'returns an 403 + error response for unpublished resources' do
        map = Map.create! invalid_attributes
        layer = FactoryBot.create(:layer, map_id: map.id, published: true)
        place = FactoryBot.create(:place, layer_id: layer.id, published: true)
        get :allplaces, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(403)
        expect(JSON.parse(response.body)['error']).to match(/Map not accessible/)
      end

      it 'can handle images with and without sorting values' do
        map = Map.create! valid_attributes
        layer = FactoryBot.create(:layer, map_id: map.id, published: true)
        place = FactoryBot.create(:place, layer_id: layer.id, published: true)
        FactoryBot.create(:image, place: place, sorting: nil)
        FactoryBot.create(:image, place: place, sorting: 1)
        get :allplaces, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    describe 'preventing n+1 queries for GET #show GET #allplaces format' do
      before do
        @map = FactoryBot.create(:map, published: true)
        @layer = FactoryBot.create(:layer, map_id: @map.id, published: true)
        # Create 6 places with relations between them
        3.times do
          place1 = FactoryBot.create(:place, :with_audio, layer_id: @layer.id, tag_list: %w[aaa bbb], published: true)
          place2 = FactoryBot.create(:place, layer_id: @layer.id, tag_list: %w[ccc], published: true)
          FactoryBot.create(:relation, relation_from: place1, relation_to: place2)
        end
      end

      def trigger_show
        get :show, params: { id: @map.id, format: 'json' }, session: valid_session
      end

      def trigger_allplaces
        get :allplaces, params: { id: @map.id, format: 'json' }, session: valid_session
      end

      it 'makes the same number of queries, no matter how many records are delivered' do
        # Measure queries before adding additional records
        x_show = count_queries { trigger_show }
        x_all = count_queries { trigger_allplaces }

        # Create 3 additional layers and 18 additional places with relations between them
        3.times do
          layer = FactoryBot.create(:layer, map_id: @map.id, published: true)
          3.times do
            place1 = FactoryBot.create(:place, :with_audio, layer_id: layer.id, tag_list: %w[aaa bbb], published: true)
            place2 = FactoryBot.create(:place, layer_id: layer.id, tag_list: %w[ccc], published: true)
            FactoryBot.create(:relation, relation_from: place1, relation_to: place2)
          end
        end

        # Measure queries after adding records
        y_show = count_queries { trigger_show }
        y_all = count_queries { trigger_allplaces }

        # Ensure query count remains the same
        expect(x_show).to eq(y_show)
        expect(x_all).to eq(y_all)
      end
    end
  end
end
