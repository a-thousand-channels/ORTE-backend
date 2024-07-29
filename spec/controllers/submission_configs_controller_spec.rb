# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubmissionConfigsController, type: :controller do
  # needed for json builder test, since json builder files are handled as views
  render_views

  describe "functionalities with logged in user with role 'admin'" do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: group.id)
      sign_in user
      @map = FactoryBot.create(:map, group_id: group.id)
      @layer = FactoryBot.create(:layer, map: @map)
      @submission_config = FactoryBot.create(:submission_config, layer_id: @layer)
    end

    let(:submission_config) do
      FactoryBot.create(:submission_config, layer_id: @layer.id)
    end

    let(:valid_attributes) do
      FactoryBot.build(:submission_config, layer_id: @layer.id).attributes
    end

    let(:invalid_attributes) do
      FactoryBot.attributes_for(:submission_config, :invalid, layer_id: @layer.id)
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        submission_config = SubmissionConfig.create! valid_attributes
        get :index, params: { layer_id: @layer.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        submission_config = SubmissionConfig.create! valid_attributes
        get :show, params: { id: submission_config.to_param, layer_id: @layer.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #show as json' do
      it 'returns a success reponse' do
        submission_config = SubmissionConfig.create! valid_attributes
        get :show, params: { id: submission_config.to_param, layer_id: @layer.id }, session: valid_session, format: 'json'
        expect(response).to have_http_status(200)
      end

      it 'returns a submission_configmark w/title' do
        submission_config = SubmissionConfig.create! valid_attributes
        get :show, params: { id: submission_config.to_param, layer_id: @layer.id }, session: valid_session, format: 'json'
        json = JSON.parse(response.body)
        expect(json['title_intro']).to eq submission_config.title_intro
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: { layer_id: @layer.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        submission_config = SubmissionConfig.create! valid_attributes
        get :edit, params: { id: submission_config.to_param, layer_id: @layer.id }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns a success response (with new coords to reposition)' do
        submission_config = SubmissionConfig.create! valid_attributes
        get :edit, params: { id: submission_config.to_param, layer_id: @layer.id, lat: 10, lng: 10 }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new SubmissionConfig' do
          expect do
            post :create, params: { submission_config: valid_attributes, layer_id: @layer.id }, session: valid_session
          end.to change(SubmissionConfig, :count).by(1)
        end

        it 'redirects to the related map' do
          post :create, params: { submission_config: valid_attributes, layer_id: @layer.id }, session: valid_session
          expect(response).to redirect_to(edit_map_layer_url(@layer.map.id, @layer.id))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { submission_config: invalid_attributes, map_id: @layer.map.id, layer_id: @layer.id }, session: valid_session
          expect(response).to have_http_status(302)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          FactoryBot.build(:submission_config, :changed, layer_id: @layer.id).attributes
        end
        let(:new_attributes_with_published) do
          FactoryBot.build(:submission_config, :changed_and_published, layer_id: @layer.id).attributes
        end

        xit 'updates the requested submission_config' do
          submission_config = SubmissionConfig.create! valid_attributes
          put :update, params: { id: submission_config.to_param, submission_config: new_attributes, layer_id: @layer.id }, session: valid_session
          submission_config.reload
          expect(submission_config.title_intro).to eq('OtherTitle')
        end

        it 'redirects to the submission_config' do
          submission_config = SubmissionConfig.create! valid_attributes
          put :update, params: { id: submission_config.to_param, submission_config: valid_attributes, layer_id: @layer.friendly_id }, session: valid_session
          expect(response).to redirect_to(edit_map_layer_url(@layer.map.id, @layer.id))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          submission_config = SubmissionConfig.create! valid_attributes
          put :update, params: { id: submission_config.to_param, submission_config: invalid_attributes, layer_id: @layer.id }, session: valid_session
          expect(response).to have_http_status(302)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested submission_config' do
        submission_config = SubmissionConfig.create! valid_attributes
        expect do
          delete :destroy, params: { id: submission_config.to_param, layer_id: @layer.id }, session: valid_session
        end.to change(SubmissionConfig, :count).by(-1)
      end

      it 'redirects to the submission_configs list' do
        submission_config = SubmissionConfig.create! valid_attributes
        delete :destroy, params: { id: submission_config.to_param, layer_id: @layer.id }, session: valid_session
        expect(response).to redirect_to(submission_configs_url)
      end
    end
  end
end
