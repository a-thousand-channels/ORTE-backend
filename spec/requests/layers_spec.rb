require 'rails_helper'

RSpec.describe "Layers", type: :request do
  describe "GET /layers" do
    it "works! (now write some real specs)" do
      get layers_path
      expect(response).to have_http_status(200)
    end
  end
end
