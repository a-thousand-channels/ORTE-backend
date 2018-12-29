require 'rails_helper'

RSpec.describe IconsetsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Iconset. As you add validations to Iconset, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # IconsetsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      iconset = Iconset.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      iconset = Iconset.create! valid_attributes
      get :show, params: {id: iconset.to_param}, session: valid_session
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
      iconset = Iconset.create! valid_attributes
      get :edit, params: {id: iconset.to_param}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Iconset" do
        expect {
          post :create, params: {iconset: valid_attributes}, session: valid_session
        }.to change(Iconset, :count).by(1)
      end

      it "redirects to the created iconset" do
        post :create, params: {iconset: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Iconset.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {iconset: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested iconset" do
        iconset = Iconset.create! valid_attributes
        put :update, params: {id: iconset.to_param, iconset: new_attributes}, session: valid_session
        iconset.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the iconset" do
        iconset = Iconset.create! valid_attributes
        put :update, params: {id: iconset.to_param, iconset: valid_attributes}, session: valid_session
        expect(response).to redirect_to(iconset)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        iconset = Iconset.create! valid_attributes
        put :update, params: {id: iconset.to_param, iconset: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested iconset" do
      iconset = Iconset.create! valid_attributes
      expect {
        delete :destroy, params: {id: iconset.to_param}, session: valid_session
      }.to change(Iconset, :count).by(-1)
    end

    it "redirects to the iconsets list" do
      iconset = Iconset.create! valid_attributes
      delete :destroy, params: {id: iconset.to_param}, session: valid_session
      expect(response).to redirect_to(iconsets_url)
    end
  end

end
