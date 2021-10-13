# frozen_string_literal: true

class TagsController < ApplicationController
  def index
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @tags = @map.places.all_tags
  end

  def show
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @tag =  ActsAsTaggableOn::Tag.find(params[:id])
    @places = Place.tagged_with(@tag.name)
  end
end
