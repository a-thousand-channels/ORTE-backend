# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::GroupsController, type: :controller do
  describe 'for guests' do
    describe 'GET #index' do
      it 'no access' do
        get :index, params: {}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "functionalities with logged in user with role 'admin'" do
    before(:all) do
      User.destroy_all
      @admin_group = FactoryBot.create(:group)
      @admin_user = FactoryBot.create(:admin_user, :group_id => @admin_group.id)
    end

    before(:each) do
      sign_in(@admin_user)
    end

    let(:admin_group) {
      @admin_group
    }
    let(:valid_attributes) {
      FactoryBot.build(:group).attributes
    }
    let(:invalid_attributes) {
      FactoryBot.attributes_for(:group, :invalid)
    }

    let(:valid_session) { {} }

    describe "GET #index" do
      it "returns a success response" do
        admin_group = Group.create! valid_attributes
        get :index, params: {}, session: valid_session
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
        admin_group = Group.create! valid_attributes
        get :edit, params: {id: admin_group.to_param}, session: valid_session
        expect(response).to have_http_status(302)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Group" do
          expect {
            post :create, params: {admin_group: valid_attributes}, session: valid_session
          }.to change(Group, :count).by(1)
        end

        it "redirects to the created group" do
          post :create, params: {admin_group: valid_attributes}, session: valid_session
          expect(response).to redirect_to(admin_groups_url)
        end
      end

      context "with invalid params" do
        xit "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {admin_group: invalid_attributes}, session: valid_session
          expect(response).to have_http_status(302)
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          skip("Add a hash of attributes valid for your model")
        }

        it "updates the requested group" do
          admin_group = Group.create! valid_attributes
          put :update, params: {id: admin_group.to_param, admin_group: new_attributes}, session: valid_session
          admin_group.reload
          skip("Add assertions for updated state")
        end

        xit "redirects to the group" do
          admin_group = Group.create! valid_attributes
          put :update, params: {id: admin_group.to_param, admin_group: valid_attributes}, session: valid_session
          expect(response).to redirect_to([:admin, admin_group])
        end
      end

      context "with invalid params" do
        xit "returns a success response (i.e. to display the 'edit' template)" do
          admin_group = Group.create! valid_attributes
          put :update, params: {id: admin_group.to_param, admin_group: invalid_attributes}, session: valid_session
          expect(response).to have_http_status(200)
        end
      end
    end

    describe "DELETE #destroy" do
      xit "destroys the requested group" do
        admin_group = Group.create! valid_attributes
        expect {
          delete :destroy, params: {id: admin_group.to_param}, session: valid_session
        }.to change(Group, :count).by(-1)
      end

      xit "redirects to the groups list" do
        admin_group = Group.create! valid_attributes
        delete :destroy, params: {id: admin_group.to_param}, session: valid_session
        expect(response).to redirect_to(admin_groups_url)
      end
    end
  end
end
