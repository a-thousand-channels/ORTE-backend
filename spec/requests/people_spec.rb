# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/people', type: :request do
  before do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group: group)
    sign_in user
    @map = create(:map, group: group)
  end

  let(:valid_attributes) do
    FactoryBot.build(:person, map: @map).attributes
  end

  let(:invalid_attributes) do
    FactoryBot.attributes_for(:person, :invalid, map: @map)
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Person.create! valid_attributes
      get map_people_url(@map)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_map_person_url(@map)
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      person = Person.create! valid_attributes
      get edit_map_person_url(@map, person)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Person' do
        expect do
          post map_people_url(@map), params: { person: valid_attributes }
        end.to change(Person, :count).by(1)
      end

      it 'redirects to the people' do
        post map_people_url(@map), params: { person: valid_attributes }
        expect(response).to redirect_to(map_people_url(@map))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Person' do
        expect do
          post map_people_url(@map), params: { person: invalid_attributes }
        end.to change(Person, :count).by(0)
      end

      it 'renders a un-successful response' do
        post map_people_url(@map), params: { person: invalid_attributes }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        FactoryBot.attributes_for(:person, :changed)
      end

      it 'updates the requested person' do
        person = Person.create! valid_attributes
        patch map_person_url(@map, person), params: { person: new_attributes }
        person.reload
        expect(person.name).to eq('OtherName')
      end

      it 'redirects to the people' do
        person = Person.create! valid_attributes
        patch map_person_url(@map, person), params: { person: new_attributes }
        person.reload
        expect(response).to redirect_to(map_people_url(@map))
      end
    end

    context 'with invalid parameters' do
      it 'renders a non-successful response' do
        person = Person.create! valid_attributes
        patch map_person_url(@map, person), params: { person: invalid_attributes }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested person' do
      person = Person.create! valid_attributes
      expect do
        delete map_person_url(@map, person)
      end.to change(Person, :count).by(-1)
    end

    it 'redirects to the people list' do
      person = Person.create! valid_attributes
      delete map_person_url(@map, person)
      expect(response).to redirect_to(map_people_url(@map))
    end
  end
end
