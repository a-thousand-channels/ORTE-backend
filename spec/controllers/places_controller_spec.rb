require 'rails_helper'

RSpec.describe PlacesController, type: :controller do

  describe "functionalities with logged in user with role 'admin'" do

    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, :group_id => group.id)
      sign_in user
      @map = FactoryBot.create(:map, :group_id => group.id)
      @layer = FactoryBot.create(:layer, :map_id => @map.id)
    end

    let(:place) {
      FactoryBot.create(:place, :layer_id => @layer.id)
    }

    let(:valid_attributes) {
      FactoryBot.build(:place, :layer_id => @layer.id).attributes
    }

    let(:invalid_attributes) {
      FactoryBot.attributes_for(:place, :invalid, :layer_id => @layer.id )
    }

    let(:valid_session) { {} }

    describe "GET #index" do
      it "returns a success response" do
        place = Place.create! valid_attributes
        get :index, params: { layer_id: @layer.id, map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        place = Place.create! valid_attributes
        get :show, params: {id: place.to_param, layer_id: @layer.id, map_id: @map.id}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new, params: { layer_id: @layer.id, map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        place = Place.create! valid_attributes
        get :edit, params: {id: place.to_param, layer_id: @layer.id, map_id: @map.id}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Place" do
          expect {
            post :create, params: {place: valid_attributes, layer_id: @layer.id, map_id: @map.id}, session: valid_session
          }.to change(Place, :count).by(1)
        end

        it "redirects to the related map" do
          post :create, params: {place: valid_attributes, layer_id: @layer.id, map_id: @map.id}, session: valid_session
          expect(response).to redirect_to(map_layer_url(@map,@layer))
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {place: invalid_attributes, layer_id: @layer.id, map_id: @map.id}, session: valid_session
          expect(response).to have_http_status(200)
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          FactoryBot.build(:place, :layer_id => @layer.id).attributes
        }

        it "updates the requested place" do
          place = Place.create! valid_attributes
          put :update, params: {id: place.to_param, place: new_attributes, layer_id: @layer.id, map_id: @map.id}, session: valid_session
          place.reload
          skip("Add assertions for updated state")
        end

        it "redirects to the place" do
          place = Place.create! valid_attributes
          put :update, params: {id: place.to_param, place: valid_attributes, layer_id: @layer.id, map_id: @map.id}, session: valid_session
          expect(response).to redirect_to(map_layer_url(@map,@layer))
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          place = Place.create! valid_attributes
          put :update, params: {id: place.to_param, place: invalid_attributes, layer_id: @layer.id, map_id: @map.id}, session: valid_session
          expect(response).to have_http_status(200)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested place" do
        place = Place.create! valid_attributes
        expect {
          delete :destroy, params: {id: place.to_param, layer_id: @layer.id, map_id: @map.id}, session: valid_session
        }.to change(Place, :count).by(-1)
      end

      it "redirects to the places list" do
        place = Place.create! valid_attributes
        delete :destroy, params: {id: place.to_param, layer_id: @layer.id, map_id: @map.id}, session: valid_session
        expect(response).to redirect_to(map_layer_places_url(@map,@layer))
      end
    end
  end
end
