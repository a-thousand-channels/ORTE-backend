# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  describe "functionalities with logged in user with role 'admin'" do
    before do
      @group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: @group.id)
      sign_in user
      @map = FactoryBot.create(:map, group_id: @group.id)
      @layer = FactoryBot.create(:layer, map_id: @map.id)
      @place = FactoryBot.create(:place, layer_id: @layer.id)
    end

    let(:video) do
      FactoryBot.create(:video, :with_file, place_id: @place.id)
    end

    let(:valid_attributes) do
      FactoryBot.attributes_for(:video, :with_file, place_id: @place.id)
    end

    let(:invalid_attributes) do
      FactoryBot.attributes_for(:video, :invalid)
    end

    let(:without_file_attributes) do
      FactoryBot.attributes_for(:video, :without_file, place_id: @place.id)
    end

    let(:with_wrong_fileformat_attributes) do
      FactoryBot.attributes_for(:video, :with_wrong_fileformat, place_id: @place.id)
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        get :index, params: { map_id: @map.id, layer_id: @layer.id, place_id: @place.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
      it 'redirects to root_url' do
        @another_group = FactoryBot.create(:group)
        @another_map = FactoryBot.create(:map, group_id: @another_group.id)
        @another_layer = FactoryBot.create(:layer, map_id: @another_map.id, title: 'Another layer title')
        @another_place = FactoryBot.create(:place, layer_id: @another_layer.id)
        get :index, params: { map_id: @another_map.id, layer_id: @another_layer.id, place_id: @another_place.id }, session: valid_session
        expect(response).to have_http_status(302)
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        video = Video.create! valid_attributes
        get :show, params: { id: video.to_param, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
      it 'redirects to root_url (if not admin)' do
        @another_group = FactoryBot.create(:group)
        user = FactoryBot.create(:user, group_id: @another_group.id)
        sign_in user
        @another_map = FactoryBot.create(:map, group_id: @another_group.id)
        @another_layer = FactoryBot.create(:layer, map_id: @another_map.id, title: 'Another layer title')
        @another_place = FactoryBot.create(:place, layer_id: @another_layer.id)
        video = Video.create! valid_attributes
        get :show, params: { id: video.to_param, map_id: @another_map.id, layer_id: @another_layer.id, place_id: @another_place.id }, session: valid_session
        expect(response).to have_http_status(302)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: { layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        video = Video.create! valid_attributes
        get :edit, params: { id: video.to_param, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Video' do
          expect do
            post :create, params: { video: valid_attributes, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
          end.to change(Video, :count).by(1)
        end

        it 'redirects to the created video' do
          post :create, params: { video: valid_attributes, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
          expect(response).to have_http_status(302)
        end

        it 'redirects to related place url' do
          post :create, params: { video: valid_attributes, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
          expect(response).to redirect_to(edit_map_layer_place_url(@map, @layer, @place))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { video: invalid_attributes, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
          expect(response).to render_template('new')
          expect(response).to have_http_status(200)
        end
      end
      context 'wit wrong fileformat' do
        it "returns a success response (i.e. to display the 'new' template)" do
          pending 'fails to prevent save with wrong fileformat'
          post :create, params: { video: with_wrong_fileformat_attributes, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
          expect(response).to render_template('new')
          expect(response).to have_http_status(200)
        end
      end
      context 'without file' do
        it "returns a success response (i.e. to display the 'new' template)" do
          pending 'fails to prevent save with missing file'
          post :create, params: { video: without_file_attributes, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
          expect(response).to render_template('new')
          expect(response).to have_http_status(200)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          FactoryBot.attributes_for(:video, :changed, place_id: @place.id)
        end

        it 'updates the requested video' do
          video = Video.create! valid_attributes
          put :update, params: { id: video.to_param, video: new_attributes, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
          video.reload
          expect(video.title).to eq('OtherTitle')
        end

        it 'redirects to the place' do
          video = Video.create! valid_attributes
          put :update, params: { id: video.to_param, video: valid_attributes, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
          expect(response).to redirect_to(edit_map_layer_place_url(@map, @layer, @place))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          video = Video.create! valid_attributes
          put :update, params: { id: video.to_param, video: invalid_attributes, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
          expect(response).to have_http_status(200)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested video' do
        video = Video.create! valid_attributes
        expect do
          delete :destroy, params: { id: video.to_param, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
        end.to change(Video, :count).by(-1)
      end

      it 'redirects to the place edit view' do
        video = Video.create! valid_attributes
        delete :destroy, params: { id: video.to_param, layer_id: @layer.id, map_id: @map.id, place_id: @place.id }, session: valid_session
        expect(response).to redirect_to(edit_map_layer_place_url(@map, @layer, @place))
      end
    end
  end
end
