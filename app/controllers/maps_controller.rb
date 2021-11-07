# frozen_string_literal: true

class MapsController < ApplicationController
  before_action :set_map, only: %i[show edit update destroy]

  before_action :redirect_to_friendly_id, only: %i[show]

  # GET /maps
  # GET /maps.json
  def index
    @maps = Map.sorted.by_user(current_user)
  end

  # GET /maps/1
  # GET /maps/1.json
  def show
    @maps = Map.sorted.by_user(current_user)
    if @map
      @map_layers = @map.layers
      respond_to do |format|
        format.html { render :show }
        format.json { render :show, filename: "orte-map-#{@map.title.parameterize}-#{I18n.l Date.today}.json" }
      end
    else
      redirect_to maps_path, notice: 'Sorry, this map could not be found.'
    end
  end

  # GET /maps/new
  def new
    @map = Map.new
    @groups = Group.by_user(current_user)
  end

  # GET /maps/1/edit
  def edit
    @map.northeast_corner = params[:northeast] if params[:northeast]
    @map.southwest_corner = params[:southwest] if params[:southwest]
  end

  # POST /maps
  # POST /maps.json
  def create
    @map = Map.new(map_params)

    respond_to do |format|
      if @map.save
        format.html { redirect_to @map, notice: 'Map was successfully created. Please create at least one layer' }
        format.json { render :show, status: :created, location: @map }
      else
        format.html { render :new }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maps/1
  # PATCH/PUT /maps/1.json
  def update
    respond_to do |format|
      if @map.update(map_params)
        format.html { redirect_to @map, notice: 'Map was successfully updated.' }
        format.json { render :show, status: :ok, location: @map }
      else
        format.html { render :edit }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maps/1
  # DELETE /maps/1.json
  def destroy
    @map.destroy
    respond_to do |format|
      format.html { redirect_to maps_url, notice: 'Map was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def redirect_to_friendly_id
    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    redirect_to @map, status: :moved_permanently if @map && request.path != map_path(@map) && request.format == 'html'
  end

  def set_map
    # flexible query: Find slugged resource, if not, find a non-slugged resoure. All that to avoid an exception if a resource is unknown or not accessible (which would happen with friendly.find)
    @map = Map.by_user(current_user).find_by_slug(params[:id]) || Map.by_user(current_user).find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def map_params
    params.require(:map).permit(:title, :subtitle, :text, :published, :script, :group_id, :northeast_corner, :southwest_corner, :iconset_id, :basemap_url, :basemap_attribution, :popup_display_mode)
  end
end
