require 'rails_helper'

RSpec.describe "Icons", type: :request do
  describe "GET /icons" do
    it "works! (now write some real specs)" do
      get icons_path
      expect(response).to have_http_status(200)
    end
  end
end
