# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Images', type: :request do
  describe 'GET /images' do
    it 'gets redirected to login' do
      get map_layer_place_images_path(1, 1, 1)
      expect(response).to have_http_status(302)
    end
  end
end
