# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  describe "functionalities with logged in user with role 'admin'" do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group: group)
      sign_in user
      @map = create(:map, group: group)
    end

    let(:person) do
      FactoryBot.create(:person, map: @map)
    end

    let(:valid_attributes) do
      FactoryBot.build(:person, map: @map).attributes
    end

    let(:invalid_attributes) do
      FactoryBot.attributes_for(:person, :invalid, map: @map)
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        person = Person.create! valid_attributes
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
        person = Person.create! valid_attributes
        get :edit, params: { id: person.to_param, map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Person' do
          expect do
            post :create, params: { person: valid_attributes, map_id: @map.id }, session: valid_session
          end.to change(Person, :count).by(1)
        end

        it 'redirects to the created person' do
          post :create, params: { person: valid_attributes, map_id: @map.id }, session: valid_session
          expect(response).to redirect_to(map_people_url(@map))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { person: invalid_attributes, map_id: @map.id }, session: valid_session
          expect(response).to have_http_status(422)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          FactoryBot.attributes_for(:person, :changed)
        end

        it 'updates the requested person' do
          person = Person.create! valid_attributes
          put :update, params: { id: person.to_param, map_id: @map.id, person: new_attributes }, session: valid_session
          person.reload
          expect(person.name).to eq('OtherName')
        end

        it 'redirects to the personset' do
          person = Person.create! valid_attributes
          put :update, params: { id: person.to_param, map_id: @map.id, person: valid_attributes }, session: valid_session
          expect(response).to redirect_to(map_people_url(@map))
        end
      end

      context 'with invalid params' do
        it 'returns an error response' do
          person = Person.create! valid_attributes
          expect do
            post :update, params: { id: person.to_param, map_id: @map.id, person: invalid_attributes }
          end.to_not change(Person, :count)

          expect(response).to have_http_status(422)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested person' do
        person = Person.create! valid_attributes
        expect do
          delete :destroy, params: { id: person.to_param, map_id: @map.id }, session: valid_session
        end.to change(Person, :count).by(-1)
      end

      it 'redirects to the persons list' do
        person = Person.create! valid_attributes
        delete :destroy, params: { id: person.to_param, map_id: @map.id }, session: valid_session
        expect(response).to redirect_to(map_people_url(@map))
      end
    end
  end
end
