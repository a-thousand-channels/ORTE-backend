# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildLogsController, type: :controller do
  describe "functionalities with logged in user with role 'admin'" do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: group.id)
      sign_in user
      @map = FactoryBot.create(:map, group_id: group.id)
      @layer = FactoryBot.create(:layer, map: @map)
    end

    let(:build_log) do
      FactoryBot.create(:build_log, map: @map, layer: @layer)
    end

    let(:valid_attributes) do
      FactoryBot.build(:build_log, map: @map, layer: @layer).attributes
    end

    let(:invalid_attributes) do
      FactoryBot.attributes_for(:build_log, map: nil, layer: @layer)
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        build_log = BuildLog.create! valid_attributes
        get :index, params: {}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #new' do
      xit 'returns a success response' do
        get :new, params: {}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        build_log = BuildLog.create! valid_attributes
        get :edit, params: { id: build_log.to_param }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new BuildLog' do
          expect do
            post :create, params: { build_log: valid_attributes }, session: valid_session
          end.to change(BuildLog, :count).by(1)
        end

        it 'redirects to the created build_log' do
          post :create, params: { build_log: valid_attributes }, session: valid_session
          expect(response).to redirect_to(build_log_url(BuildLog.last))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { build_log: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(422)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          FactoryBot.attributes_for(:build_log, :changed)
        end

        it 'updates the requested build_log' do
          build_log = BuildLog.create! valid_attributes
          put :update, params: { id: build_log.to_param, build_log: new_attributes }, session: valid_session
          build_log.reload
          expect(build_log.output).to eq('OtherString')
        end

        it 'redirects to the place' do
          build_log = BuildLog.create! valid_attributes
          put :update, params: { id: build_log.to_param, build_log: valid_attributes }, session: valid_session
          expect(response).to redirect_to(build_log_url(build_log))
        end
      end

      context 'with invalid params' do
        xit 'returns an error response' do
          build_log = BuildLog.create! valid_attributes
          expect do
            post :update, params: { id: build_log.to_param, build_log: invalid_attributes }
          end.to_not change(BuildLog, :count)

          expect(response).to have_http_status(422)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested build_log' do
        build_log = BuildLog.create! valid_attributes
        expect do
          delete :destroy, params: { id: build_log.to_param }, session: valid_session
        end.to change(BuildLog, :count).by(-1)
      end

      it 'redirects to the place' do
        build_log = BuildLog.create! valid_attributes
        delete :destroy, params: { id: build_log.to_param }, session: valid_session
        expect(response).to redirect_to(build_logs_url)
      end
    end
  end
end
