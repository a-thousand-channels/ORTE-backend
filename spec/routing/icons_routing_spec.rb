require "rails_helper"

RSpec.describe IconsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/icons").to route_to("icons#index")
    end

    it "routes to #new" do
      expect(:get => "/icons/new").to route_to("icons#new")
    end

    it "routes to #show" do
      expect(:get => "/icons/1").to route_to("icons#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/icons/1/edit").to route_to("icons#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/icons").to route_to("icons#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/icons/1").to route_to("icons#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/icons/1").to route_to("icons#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/icons/1").to route_to("icons#destroy", :id => "1")
    end

  end
end
