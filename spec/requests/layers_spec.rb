# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Layers', type: :request do
  describe 'GET /maps/1/layers' do
    it 'gets redirected to login' do
      get map_layers_path(1)
      expect(response).to have_http_status(302)
    end
  end
end
