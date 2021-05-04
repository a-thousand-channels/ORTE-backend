require "rails_helper"

RSpec.describe SubmissionConfigsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/submission_configs").to route_to("submission_configs#index")
    end

    it "routes to #new" do
      expect(get: "/submission_configs/new").to route_to("submission_configs#new")
    end

    it "routes to #show" do
      expect(get: "/submission_configs/1").to route_to("submission_configs#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/submission_configs/1/edit").to route_to("submission_configs#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/submission_configs").to route_to("submission_configs#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/submission_configs/1").to route_to("submission_configs#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/submission_configs/1").to route_to("submission_configs#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/submission_configs/1").to route_to("submission_configs#destroy", id: "1")
    end
  end
end
