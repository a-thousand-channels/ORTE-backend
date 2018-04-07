# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  describe 'GET /admin_users' do
    it 'redirects for guests' do
      get admin_users_path
      expect(response).to have_http_status(302)
    end
  end

  describe 'for signed in users' do
    before do
      @user = FactoryBot.create(:user)
      sign_in @user
    end
    it 'redirects for pages/show' do
      get admin_users_path
      expect(response).to have_http_status(200)
    end
  end
end
