require "rails_helper"

RSpec.describe RelationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/maps/1/relations").to route_to("relations#index", map_id: '1')
    end

    it "routes to #new" do
      expect(get: "/maps/1/relations/new").to route_to("relations#new", map_id: '1')
    end

    it "routes to #edit" do
      expect(get: "/maps/1/relations/1/edit").to route_to("relations#edit", id: "1", map_id: '1')
    end


    it "routes to #create" do
      expect(post: "/maps/1/relations").to route_to("relations#create", map_id: '1')
    end

    it "routes to #update via PUT" do
      expect(put: "/maps/1/relations/1").to route_to("relations#update", id: "1", map_id: '1')
    end

    it "routes to #update via PATCH" do
      expect(patch: "/maps/1/relations/1").to route_to("relations#update", id: "1", map_id: '1')
    end

    it "routes to #destroy" do
      expect(delete: "/maps/1/relations/1").to route_to("relations#destroy", id: "1", map_id: '1')
    end
  end
end
