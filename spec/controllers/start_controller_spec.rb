# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StartController, type: :controller do
  # TODO: check as non logged in user

  before(:all) do
    User.destroy_all
    @my_group = FactoryBot.create(:group)
    @my_map1 = FactoryBot.create(:map, group_id: @my_group.id)
    @my_map2 = FactoryBot.create(:map, group_id: @my_group.id)
    @user = FactoryBot.create(:user, group_id: @my_group.id)
  end

  describe 'GET #index as user' do
    it 'returns success' do
      sign_in(@user)
      get :index
      expect(response).to redirect_to(maps_url)
    end
  end

  describe 'GET #info as user' do
    it 'returns success' do
      sign_in(@user)
      get :info
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #settings as user' do
    before do
      sign_in(@user)
    end

    it 'returns success' do
      get :settings
      expect(response).to have_http_status(200)
    end

    it 'assigns vars for site stats' do
      get :settings
      @other_group = FactoryBot.create(:group)
      @other_map = FactoryBot.create(:map, group_id: @other_group.id)
      expect(assigns(:groups)).to eq([@my_group])
      expect(assigns(:maps)).to eq([@my_map1, @my_map2])
    end
  end

  describe 'update profile as user' do
    before do
      sign_in(@user)
    end

    it 'edit response should be success' do
      get :edit_profile, params: { id: User.first.id }
      expect(response).to have_http_status(200)
    end

    it 'update response should be success' do
      put :update_profile, params: { user: { id: @user.id, email: @user.email, password: 'Test1234567890?' } }
      expect(response).to redirect_to(root_url)
      expect(flash[:notice]).to match 'Your profile was successfully updated.'
    end

    it 'incomplete update response should be not success' do
      put :update_profile, params: { user: { id: User.first.id, email: '', password: '' } }
      expect(response).to render_template('start/edit_profile')
    end
  end
end
