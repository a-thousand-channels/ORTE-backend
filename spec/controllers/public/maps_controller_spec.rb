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

      context 'with measured performance to prevent n+1 queries' do
        before do
          @map = FactoryBot.create(:map, published: true)
          @layer = FactoryBot.create(:layer, map_id: @map.id, published: true)
          # Create 6 places with relations between them
          3.times do
            place1 = FactoryBot.create(:place, :with_audio, layer_id: @layer.id, published: true)
            place2 = FactoryBot.create(:place, layer_id: @layer.id, published: true)
            FactoryBot.create(:relation, relation_from: place1, relation_to: place2)
          end
        end

        def trigger
          get :show, params: { id: @map.id, format: 'json' }, session: valid_session
        end

        it 'makes the same number of queries, no matter how many records are delivered' do
          # Measure queries before adding additional records
          x = count_queries { trigger }

          # Create 3 additional layers and 18 additional places with relations between them
          3.times do
            layer = FactoryBot.create(:layer, map_id: @map.id, published: true)
            3.times do
              place1 = FactoryBot.create(:place, :with_audio, layer_id: layer.id, published: true)
              place2 = FactoryBot.create(:place, layer_id: layer.id, published: true)
              FactoryBot.create(:relation, relation_from: place1, relation_to: place2)
            end
          end

          # Measure queries after adding records
          y = count_queries { trigger }

          # Ensure query count remains the same
          expect(x).to eq(y)
        end
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
    end
  end
end
