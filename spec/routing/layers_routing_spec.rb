require "rails_helper"

RSpec.describe LayersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/layers").to route_to("layers#index")
    end

    it "routes to #new" do
      expect(:get => "/layers/new").to route_to("layers#new")
    end

    it "routes to #show" do
      expect(:get => "/layers/1").to route_to("layers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/layers/1/edit").to route_to("layers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/layers").to route_to("layers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/layers/1").to route_to("layers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/layers/1").to route_to("layers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/layers/1").to route_to("layers#destroy", :id => "1")
    end

  end
end
