# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Icons', type: :request do
  describe 'GET /iconsets/1/icons' do
    it 'gets redirected to login' do
      get iconset_icons_path(1)
      expect(response).to have_http_status(302)
    end
  end
end
