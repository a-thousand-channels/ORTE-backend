# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Iconsets', type: :request do
  describe 'GET /iconsets' do
    it 'gets redirected to login' do
      get iconsets_path
      expect(response).to have_http_status(302)
    end
  end
end
