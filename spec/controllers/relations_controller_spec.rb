# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RelationsController, type: :controller do
  describe "functionalities with logged in user with role 'admin'" do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: group.id)
      sign_in user
      @map = FactoryBot.create(:map, group_id: group.id)
    end

    let(:relation) do
      FactoryBot.create(:relation)
    end

    let(:valid_attributes) do
      p1 = create(:place)
      p2 = create(:place)
      FactoryBot.build(:relation, relation_from_id: p1.id, relation_to_id: p2.id).attributes
    end

    let(:invalid_attributes) do
      FactoryBot.attributes_for(:relation, :invalid)
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        relation = Relation.create! valid_attributes
        get :index, params: { map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: { map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        relation = Relation.create! valid_attributes
        get :edit, params: { map_id: @map.id, id: relation.to_param }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Relation' do
          expect do
            post :create, params: { map_id: @map.id, relation: valid_attributes }, session: valid_session
          end.to change(Relation, :count).by(1)
        end

        it 'redirects to the created relation' do
          post :create, params: { map_id: @map.id, relation: valid_attributes }, session: valid_session
          expect(response).to redirect_to(map_relations_url(@map))
        end
      end

      context 'with invalid params' do
        xit "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { map_id: @map.id, relation: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(422)
        end
      end
    end



    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          p1 = create(:place)
          p2 = create(:place)
          FactoryBot.attributes_for(:relation, :changed, relation_from_id: p1.id, relation_to_id: p2.id)
        end

        it 'updates the requested relation' do
          relation = Relation.create! valid_attributes
          put :update, params: { map_id: @map.id, id: relation.to_param, relation: new_attributes }, session: valid_session
          relation.reload
          expect(relation.rtype).to eq('sequence')
        end

        it 'redirects to the relationset' do
          relation = Relation.create! valid_attributes
          put :update, params: { map_id: @map.id, id: relation.to_param, relation: new_attributes }, session: valid_session
          expect(response).to redirect_to(map_relations_url(@map))
        end
      end

      context 'with invalid params' do
        it "returns an error response" do
          relation = Relation.create! valid_attributes
          expect{
            post :update, params: { map_id: @map.id, id: relation.to_param, relation: invalid_attributes }
          }.to_not change(Relation,:count)

          expect(response).to have_http_status(422)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested relation' do
        relation = Relation.create! valid_attributes
        expect do
          delete :destroy, params: { map_id: @map.id, id: relation.to_param }, session: valid_session
        end.to change(Relation, :count).by(-1)
      end

      it 'redirects to the relations list' do
        relation = Relation.create! valid_attributes
        delete :destroy, params: { map_id: @map.id, id: relation.to_param }, session: valid_session
        expect(response).to redirect_to(map_relations_url(@map))
      end
    end
  end
end
