require 'rails_helper'

RSpec.describe "Iconsets", type: :request do
  describe "GET /iconsets" do
    it "works! (now write some real specs)" do
      get iconsets_path
      expect(response).to have_http_status(200)
    end
  end
end
