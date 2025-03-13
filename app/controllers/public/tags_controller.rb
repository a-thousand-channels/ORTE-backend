# frozen_string_literal: true

class Public::TagsController < ActionController::Base
  before_action :cors_set_access_control_headers

  protect_from_forgery with: :exception

  def index
    map = Map.published.find_by_slug(params[:map_id]) || Map.published.find_by_id(params[:map_id])
    respond_to do |format|
      if map
        if params[:layer_id]
          layer = Layer.published.find_by_slug(params[:layer_id]) || Layer.published.find_by_id(params[:layer_id])
          @tags = layer.places.published.all_tags.order(:name)
        else
          @tags = map.places.published.all_tags.order(:name)
        end
        format.json { render :index, tags: @tags }
      else
        format.json { render json: { error: 'Map not accessible' }, status: :forbidden }
      end
    end
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
end
