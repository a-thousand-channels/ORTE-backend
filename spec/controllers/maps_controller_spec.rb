require 'rails_helper'

RSpec.describe MapsController, type: :controller do

  describe "functionalities with logged in user with role 'admin'" do

    before do
      @group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, :group_id => @group.id)
      sign_in user
    end

    let(:map) {
      FactoryBot.create(:map, :group_id => @group.id)
    }

    let(:valid_attributes) {
      FactoryBot.build(:map, :group_id => @group.id).attributes
    }

    let(:invalid_attributes) {
      FactoryBot.attributes_for(:map, :invalid, :group_id => @group.id )
    }

    let(:valid_session) { {} }

    describe "GET #index" do
      it "returns a success response" do
        map = Map.create! valid_attributes
        get :index, params: {}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        map = Map.create! valid_attributes
        get :show, params: {id: map.to_param}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new, params: {}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        map = Map.create! valid_attributes
        get :edit, params: {id: map.to_param}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Map" do
          expect {
            post :create, params: {map: valid_attributes}, session: valid_session
          }.to change(Map, :count).by(1)
        end

        it "redirects to the created map" do
          post :create, params: {map: valid_attributes}, session: valid_session
          expect(response).to redirect_to(Map.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {map: invalid_attributes}, session: valid_session
          expect(response).to have_http_status(302)
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          skip("Add a hash of attributes valid for your model")
        }

        it "updates the requested map" do
          map = Map.create! valid_attributes
          put :update, params: {id: map.to_param, map: new_attributes}, session: valid_session
          map.reload
          skip("Add assertions for updated state")
        end

        it "redirects to the map" do
          map = Map.create! valid_attributes
          put :update, params: {id: map.to_param, map: valid_attributes}, session: valid_session
          expect(response).to redirect_to(map)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          map = Map.create! invalid_attributes
          put :update, params: {id: map.to_param, map: invalid_attributes}, session: valid_session
          expect(response).to have_http_status(302)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested map" do
        map = Map.create! valid_attributes
        expect {
          delete :destroy, params: {id: map.to_param}, session: valid_session
        }.to change(Map, :count).by(-1)
      end

      it "redirects to the maps list" do
        map = Map.create! valid_attributes
        delete :destroy, params: {id: map.to_param}, session: valid_session
        expect(response).to redirect_to(maps_url)
      end
    end
  end
end
