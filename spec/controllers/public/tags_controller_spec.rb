# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::TagsController, type: :controller do
  render_views

  describe 'functionalities with anonymous access' do
    before do
      @map = FactoryBot.create(:map, published: true)
      @layer = FactoryBot.create(:layer, map_id: @map.id)
    end
    let(:valid_session) { {} }

    describe 'GET #index' do
      context 'when map is not available' do
        it 'returns a 403 if map is not available' do
          get :index, params: { map_id: 'notexisting', format: 'json' }, session: valid_session
          expect(response).to have_http_status(403)
        end
      end

      context 'when map is available' do
        it 'returns a success response and a list of all available tags, ordered by name' do
          FactoryBot.create(:tag, name: 'aaa') # not used tag should not be returned
          FactoryBot.create(:place, layer_id: @layer.id, published: true, tag_list: %w[ddd])
          FactoryBot.create(:place, layer_id: @layer.id, published: true, tag_list: %w[bbb ddd])

          get :index, params: { map_id: @map.id, format: 'json' }, session: valid_session

          expect(response).to have_http_status(200)
          json = response.parsed_body
          expect(json[0]['name']).to eq 'bbb'
          expect(json[0]['taggings_count']).to eq 1
          expect(json[1]['name']).to eq 'ddd'
          expect(json[1]['taggings_count']).to eq 2
          expect(json.length).to eq 2
        end
      end
    end
  end
end
