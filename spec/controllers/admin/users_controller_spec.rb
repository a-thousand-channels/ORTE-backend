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
      @group = FactoryBot.create(:group)
      @user = FactoryBot.create(:user, group_id: @group.id)
    end

    before(:each) do
      sign_in(@user)
    end

    describe 'GET #index' do
      xit 'Should redirect to startpage with a friendly message' do
        pending('We need a role-based auth model')
      end
    end

  end

  describe "functionalities with logged in user with role 'admin'" do
    before(:all) do
      User.destroy_all
      @admin_group = FactoryBot.create(:group)
      @other_group = FactoryBot.create(:group)
      @admin_user = FactoryBot.create(:admin_user, group_id: @admin_group.id)
      @other_user = FactoryBot.create(:admin_user, group_id: @other_group.id)
    end

    before(:each) do
      sign_in(@admin_user)
    end

    # This should return the minimal set of attributes required to create a valid
    # User. As you add validations to Admin::User, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      { email: 'admin@domain.com',
        password: '1234567890ß',
        group: @admin_group }
    end

    let(:invalid_attributes) do
      { email: '',
        password: 'test' }
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
      it 'assigns nil as @admin_user' do
        expect(assigns(:admin_user)).to eq(nil)
      end
      it 'redirects to edit form' do
        user = User.create! valid_attributes
        get :show, params: { id: user.to_param }, session: valid_session
        expect(response).to redirect_to(edit_admin_user_path(user))
      end
    end

    describe 'GET #new' do
      it 'assigns a new admin_user as @admin_user' do
        get :new, params: {}, session: valid_session
        expect(assigns(:admin_user)).to be_a_new(User)
      end

      it 'assigns your groups as @groups ' do
        get :new, params: {}, session: valid_session
        expect(assigns(:groups)).to eq([@admin_group])
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
      before(:all) do
        @new_admin_user_attributes = FactoryBot.attributes_for(:user, group_id: @admin_group.id)
      end

      context 'with valid params' do
        it 'creates a new Admin::User', focus: false do
          expect do
            post :create, params: { admin_user: @new_admin_user_attributes }, session: valid_session
          end.to change(User, :count).by(1)
        end

        it 'assigns a newly created admin_user as @admin_user' do
          post :create, params: { admin_user: @new_admin_user_attributes }, session: valid_session
          expect(assigns(:admin_user)).to be_a(User)
        end

        it 'redirects to the created admin_user' do
          post :create, params: { admin_user: @new_admin_user_attributes }, session: valid_session
          expect(response).to redirect_to(admin_users_url)
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved admin_user as @admin_user' do
          expect {
            post :create, params: { admin_user: invalid_attributes }, session: valid_session
          }.not_to raise_error
        end

        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { admin_user: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(200)
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
          put :update, params: { id: user.to_param, admin_user: new_attributes }, session: valid_session
          expect(assigns(:admin_user)).to eq(user)
        end

        it 'redirects to the admin_user' do
          user = User.create! valid_attributes
          put :update, params: { id: user.to_param, admin_user: valid_attributes }, session: valid_session
          expect(response).to redirect_to(admin_users_url)
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

  describe "Functionalities with logged in user with role 'admin' and member of the group 'admin' (which makes them superuser)" do
    before(:all) do
      User.destroy_all
      @admin_group = FactoryBot.create(:group, title: 'Admin')
      @other_group = FactoryBot.create(:group)
      @admin_user = FactoryBot.create(:admin_user, group_id: @admin_group.id)
      @other_user = FactoryBot.create(:admin_user, group_id: @other_group.id)
    end

    before(:each) do
      sign_in(@admin_user)
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      xit 'assigns all admin_users as @admin_users' do
        get :index, params: {}, session: valid_session
        expect(assigns(:admin_users)).to eq([@admin_user,@other_user])
        expect(response).to render_template('index')
      end
    end
  end
end
