# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Layers', type: :request do
  describe 'GET /submission_config/1' do
    it 'gets redirected to login' do
      get submission_config_path(1)
      expect(response).to have_http_status(302)
    end
  end
end
