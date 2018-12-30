require 'rails_helper'

RSpec.describe "Groups", type: :request do
  describe "GET /admin/groups" do
    it "gets redirected to login" do
      get admin_groups_path
      expect(response).to have_http_status(302)
    end
  end
end
