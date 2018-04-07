# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe 'for guests' do
    describe 'GET #index' do
      it 'no access' do
        get :index, params: {}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "functionalities with logged in user with role 'user'" do
    before(:all) do
      User.destroy_all
      @admin_user = FactoryBot.create(:admin_user)
    end

    before(:each) do
      sign_in(@admin_user)
    end

    # This should return the minimal set of attributes required to create a valid
    # User. As you add validations to Admin::User, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      { email:      'admin@domain.com',
        password:   '1234567890ß' }
    end

    let(:invalid_attributes) do
      { email:      '',
        password:   'test' }
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # Admin::UsersController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'assigns all admin_users as @admin_users' do
        get :index, params: {}, session: valid_session
        expect(assigns(:admin_users)).to eq([@admin_user])
        expect(response).to render_template('index')
      end
    end

    describe 'GET #show' do
      it 'assigns the requested admin_user as @admin_user' do
        get :show, params: { id: @admin_user.to_param }, session: valid_session
        expect(assigns(:admin_user)).to eq(@admin_user)
      end
    end

    describe 'GET #new' do
      it 'assigns a new admin_user as @admin_user' do
        get :new, params: {}, session: valid_session
        expect(assigns(:admin_user)).to be_a_new(User)
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested admin_user as @admin_user' do
        user = User.create! valid_attributes
        get :edit, params: { id: user.to_param }, session: valid_session
        expect(assigns(:admin_user)).to eq(user)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Admin::User' do
          expect do
            post :create, params: { admin_user: valid_attributes }, session: valid_session
          end.to change(User, :count).by(1)
        end

        it 'assigns a newly created admin_user as @admin_user' do
          post :create, params: { admin_user: valid_attributes }, session: valid_session
          expect(assigns(:admin_user)).to be_a(User)
          expect(assigns(:admin_user)).to be_persisted
        end

        it 'redirects to the created admin_user' do
          post :create, params: { admin_user: valid_attributes }, session: valid_session
          expect(response).to redirect_to([:admin, User.last])
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved admin_user as @admin_user' do
          post :create, params: { admin_user: invalid_attributes }, session: valid_session
          expect(assigns(:admin_user)).to be_a_new(User)
        end

        it "re-renders the 'new' template" do
          post :create, params: { admin_user: invalid_attributes }, session: valid_session
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          { email: 'abc@def.ghi' }
        end

        it 'updates the requested admin_user' do
          user = User.create! valid_attributes
          put :update, params: { id: user.to_param, admin_user: new_attributes }, session: valid_session
          user.reload
          expect(user.email).to eq 'abc@def.ghi'
        end

        it 'assigns the requested admin_user as @admin_user' do
          user = User.create! valid_attributes
          put :update, params: { id: user.to_param, admin_user: valid_attributes }, session: valid_session
          expect(assigns(:admin_user)).to eq(user)
        end

        it 'redirects to the admin_user' do
          user = User.create! valid_attributes
          put :update, params: { id: user.to_param, admin_user: valid_attributes }, session: valid_session
          expect(response).to redirect_to([:admin, user])
        end
      end

      context 'with invalid params' do
        it 'assigns the admin_user as @admin_user' do
          user = User.create! valid_attributes
          put :update, params: { id: user.to_param, admin_user: invalid_attributes }, session: valid_session
          expect(assigns(:admin_user)).to eq(user)
        end

        it "re-renders the 'edit' template" do
          user = User.create! valid_attributes
          put :update, params: { id: user.to_param, admin_user: invalid_attributes }, session: valid_session
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested admin_user' do
        user = User.create! valid_attributes
        expect do
          delete :destroy, params: { id: user.to_param }, session: valid_session
        end.to change(User, :count).by(-1)
      end

      it 'redirects to the admin_users list' do
        user = User.create! valid_attributes
        delete :destroy, params: { id: user.to_param }, session: valid_session
        expect(response).to redirect_to(admin_users_url)
      end
    end
  end
end
