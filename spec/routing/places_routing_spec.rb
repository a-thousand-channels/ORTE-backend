require "rails_helper"

RSpec.describe PlacesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/maps/1/layers/1/places").to route_to("places#index", layer_id: '1', map_id: '1')
    end

    it "routes to #new" do
      expect(:get => "/maps/1/layers/1/places/new").to route_to("places#new", layer_id: '1', map_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/maps/1/layers/1/places/1").to route_to("places#show", :id => "1", layer_id: '1', map_id: '1')
    end

    it "routes to #edit" do
      expect(:get => "/maps/1/layers/1/places/1/edit").to route_to("places#edit", :id => "1", layer_id: '1', map_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/maps/1/layers/1/places").to route_to("places#create", layer_id: '1', map_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/maps/1/layers/1/places/1").to route_to("places#update", :id => "1", layer_id: '1', map_id: '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/maps/1/layers/1/places/1").to route_to("places#update", :id => "1", layer_id: '1', map_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/maps/1/layers/1/places/1").to route_to("places#destroy", :id => "1", layer_id: '1', map_id: '1')
    end

  end
end
