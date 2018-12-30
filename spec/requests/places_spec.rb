require 'rails_helper'

RSpec.describe "Places", type: :request do
  describe "GET /maps/1/layers/1/places" do
    it "gets redirected to login" do
      get map_layer_places_path(1,1)
      expect(response).to have_http_status(302)
    end
  end
end
