# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  describe "functionalities with logged in user with role 'admin'" do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: group.id)
      sign_in user
      @map = FactoryBot.create(:map, group_id: group.id)
      @layer = FactoryBot.create(:layer, map_id: @map.id)
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        place = FactoryBot.create(:place, layer_id: @layer.id)
        get :index, params: { map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        place = FactoryBot.create(:place, layer_id: @layer.id)
        tag = FactoryBot.create(:tag)
        get :show, params: { map_id: @map.to_param, id: tag.to_param }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end
end
