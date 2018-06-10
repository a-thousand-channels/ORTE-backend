# frozen_string_literal: true

class Public::MapsController  < ActionController::Base

  # GET /maps.json
  def index
    @maps = Map.published
    respond_to do |format|
      if @maps
        format.json { render json: @maps }
      else
        format.json { head :no_content }
      end
    end
  end

  # GET /maps/1.json
  def show
    @map = Map.published.find_by_id(params[:id])

    respond_to do |format|
      if @map
        @map_layers = @map.layers.published
      end
      if @map_layers.present?
        format.json { render :show, location: @map }
      else
        if @map.present?
          format.json { render :show, location: @map }
        else
          # format.json { head :no_content }
          format.json { render json: {error: 'Map not accessible'}, status: :forbidden }
        end
      end
    end
  end


end
