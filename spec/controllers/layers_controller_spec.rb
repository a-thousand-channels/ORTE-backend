require 'rails_helper'

RSpec.describe LayersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Layer. As you add validations to Layer, be sure to
  # adjust the attributes here as well.
  describe "functionalities with logged in user with role 'admin'" do


    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, :group_id => group.id)
      sign_in user
      @map = FactoryBot.create(:map, :group_id => group.id)
    end

    let(:layer) {
      FactoryBot.create(:layer, :map_id => @map.id)
    }


    let(:valid_attributes) {
      FactoryBot.build(:layer, :map_id => @map.id).attributes
    }

    let(:invalid_attributes) {
      FactoryBot.attributes_for(:layer, :invalid, :map_id => @map.id )
    }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # LayersController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET #index" do
      it "returns a success response" do
        layer = Layer.create! valid_attributes
        get :index, params: { map_id: @map.id }, session: valid_session
        expect(response).to be_success
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        layer = Layer.create! valid_attributes
        get :show, params: { map_id: @map.id, id: layer.to_param}, session: valid_session
        expect(response).to be_success
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new, params: {map_id: @map.id }, session: valid_session
        expect(response).to be_success
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        layer = Layer.create! valid_attributes
        get :edit, params: {map_id: @map.id, id: layer.to_param}, session: valid_session
        expect(response).to be_success
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Layer" do
          expect {
            post :create, params: {map_id: @map.id, layer: valid_attributes}, session: valid_session
          }.to change(Layer, :count).by(1)
        end

        it "redirects to the map" do
          post :create, params: {map_id: @map.id, layer: valid_attributes}, session: valid_session
          expect(response).to redirect_to(map_path(@map.id))
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {map_id: @map.id,  layer: invalid_attributes}, session: valid_session
          expect(response.status).to eq(302)
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          skip("Add a hash of attributes valid for your model")
        }

        it "updates the requested layer" do
          layer = Layer.create! valid_attributes
          put :update, params: {map_id: @map.id, id: layer.to_param, layer: new_attributes}, session: valid_session
          layer.reload
          skip("Add assertions for updated state")
        end

        it "redirects to the layer" do
          layer = Layer.create! valid_attributes
          put :update, params: {map_id: @map.id, id: layer.to_param, layer: valid_attributes}, session: valid_session
          expect(response).to redirect_to(map_path(@map.id))
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          layer = Layer.create! valid_attributes
          put :update, params: {map_id: @map.id, id: layer.to_param, layer: invalid_attributes}, session: valid_session
          expect(response.status).to eq(302)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested layer" do
        layer = Layer.create! valid_attributes
        expect {
          delete :destroy, params: {map_id: @map.id, id: layer.to_param}, session: valid_session
        }.to change(Layer, :count).by(-1)
      end

      it "redirects to the layers list" do
        layer = Layer.create! valid_attributes
        delete :destroy, params: {map_id: @map.id, id: layer.to_param}, session: valid_session
        expect(response).to redirect_to(map_url(@map))
      end
    end
  end
end
