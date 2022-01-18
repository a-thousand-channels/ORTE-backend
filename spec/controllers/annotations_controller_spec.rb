# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnnotationsController, type: :controller do
  describe "functionalities with logged in user with role 'admin'" do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: group.id)
      sign_in user
      @map = FactoryBot.create(:map, group_id: group.id)
      @layer = FactoryBot.create(:layer, map: @map)
      @place = FactoryBot.create(:place, layer: @layer)
    end

    let(:annotation) do
      FactoryBot.create(:annotation, place: @place)
    end

    let(:valid_attributes) do
      FactoryBot.build(:annotation, place: @place).attributes
    end

    let(:invalid_attributes) do
      FactoryBot.attributes_for(:annotation, :invalid, place: @place)
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        annotation = Annotation.create! valid_attributes
        get :index, params: {}, session: valid_session
        expect(response).to have_http_status(302)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: {}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        annotation = Annotation.create! valid_attributes
        get :edit, params: { id: annotation.to_param }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Annotation' do
          expect do
            post :create, params: { annotation: valid_attributes }, session: valid_session
          end.to change(Annotation, :count).by(1)
        end

        it 'redirects to the created annotation' do
          post :create, params: { annotation: valid_attributes }, session: valid_session
          expect(response).to redirect_to(map_layer_place_url(@map, @layer, @place))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { annotation: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(422)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          FactoryBot.attributes_for(:annotation, :changed)
        end

        it 'updates the requested annotation' do
          annotation = Annotation.create! valid_attributes
          put :update, params: { id: annotation.to_param, annotation: new_attributes }, session: valid_session
          annotation.reload
          expect(annotation.text).to eq('OtherText')
        end

        it 'redirects to the place' do
          annotation = Annotation.create! valid_attributes
          put :update, params: { id: annotation.to_param, annotation: valid_attributes }, session: valid_session
          expect(response).to redirect_to(map_layer_place_url(@map, @layer, @place))
        end
      end

      context 'with invalid params' do
        it 'returns an error response' do
          annotation = Annotation.create! valid_attributes
          expect do
            post :update, params: { id: annotation.to_param, annotation: invalid_attributes }
          end.to_not change(Annotation, :count)

          expect(response).to have_http_status(422)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested annotation' do
        annotation = Annotation.create! valid_attributes
        expect do
          delete :destroy, params: { id: annotation.to_param }, session: valid_session
        end.to change(Annotation, :count).by(-1)
      end

      it 'redirects to the place' do
        annotation = Annotation.create! valid_attributes
        delete :destroy, params: { id: annotation.to_param }, session: valid_session
        expect(response).to redirect_to(map_layer_place_url(@map, @layer, @place))
      end
    end
  end
end
