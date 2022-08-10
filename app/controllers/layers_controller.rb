# frozen_string_literal: true

class LayersController < ApplicationController
  before_action :set_layer, only: %i[images show edit update destroy annotations relations pack build]

  before_action :redirect_to_friendly_id, only: %i[show]

  protect_from_forgery except: :show

  require 'color-generator'

  # GET /layers
  # GET /layers.json
  def index
    @map = Map.sorted.by_user(current_user).friendly.find(params[:map_id])
    @layers = @map.layers
  end

  def images
    @map = Map.sorted.by_user(current_user).friendly.find(params[:map_id])
  end

  def search
    @map = Map.sorted.by_user(current_user).friendly.find(params[:map_id])
    @layers = @map.layers
    @query = params[:q][:query]
    @places = @map.places.where('places.title LIKE :query OR places.teaser LIKE :query OR places.text LIKE :query', query: "%#{@query}%")
  end

  def pack
    @build_logs = BuildLog.where(map_id: @map.id, layer_id: @layer.id).order(created_at: :desc)
    BuildChannel.broadcast_to current_user, content: 'LayersController::pack'
  end

  def build
    if params['layer']['build']
      Build::Maptogo.new(current_user, @map, @layer).build
      head :ok
    else
      BuildChannel.broadcast_to current_user, content: 'Nothing to do...'
    end
  end

  def relations; end

  def annotations; end

  # GET /layers/1
  # GET /layers/1.json
  def show
    @maps = Map.sorted.by_user(current_user)
    redirect_to maps_path, notice: 'Sorry, this map could not be found.' and return unless @map

    @map_layers = @map.layers

    if @layer
      if @layer.map && @layer.use_background_from_parent_map && @layer.map.basemap_url && @layer.map.background_color
        @layer.basemap_url = @layer.map.basemap_url
        @layer.basemap_attribution = @layer.map.basemap_attribution
        @layer.background_color = @layer.map.background_color
      end
      @places = @layer.places
      @place = Place.find(params[:place_id]) if params[:remap]
      respond_to do |format|
        format.html { render :show }
        format.json { render :show }
        format.csv { send_data @places.to_csv, filename: "orte-map-#{@layer.map.title.parameterize}-layer-#{@layer.title.parameterize}-#{I18n.l Date.today}.csv" }
      end
    else
      redirect_to maps_path, notice: 'Sorry, this layer could not be found.'
    end
  end

  # GET /layers/new
  def new
    @layer = Layer.new
    generator = ColorGenerator.new saturation: 0.8, lightness: 0.7
    @layer.color = "##{generator.create_hex}"
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @colors_selectable = []
    6.times do
      @colors_selectable << "##{generator.create_hex}"
    end

    if @layer.map && @layer.use_background_from_parent_map && @layer.map.basemap_url && @layer.map.background_color
      @layer.basemap_url = @layer.map.basemap_url
      @layer.basemap_attribution = @layer.map.basemap_attribution
      @layer.background_color = @layer.map.background_color
    end

    return unless @layer.use_mapcenter_from_parent_map && @layer.map && @layer.map.mapcenter_lat && @layer.map.mapcenter_lon && @layer.map.zoom

    @layer.mapcenter_lat = @layer.map.mapcenter_lat
    @layer.mapcenter_lon = @layer.map.mapcenter_lon
    @layer.zoom = @layer.map.zoom
  end

  # GET /layers/1/edit
  def edit
    generator = ColorGenerator.new saturation: 0.8, lightness: 0.7
    if !@layer.color || params[:recolor]
      @layer.color = "##{generator.create_hex}"
    elsif @layer.color && !@layer.color.include?('#')
      @layer.color = "##{@layer.color}"
    end
    @colors_selectable = []
    6.times do
      @colors_selectable << "##{generator.create_hex}"
    end

    @layer.use_background_from_parent_map = false unless @layer.map.basemap_url && @layer.map.basemap_attribution && @layer.map.background_color

    if @layer.map && @layer.use_background_from_parent_map && @layer.map.basemap_url && @layer.map.background_color
      @layer.basemap_url = @layer.map.basemap_url
      @layer.basemap_attribution = @layer.map.basemap_attribution
      @layer.background_color = @layer.map.background_color
    end

    @layer.use_mapcenter_from_parent_map = false unless @layer.map.mapcenter_lat && @layer.map.mapcenter_lon && @layer.map.zoom

    return unless @layer.use_mapcenter_from_parent_map && @layer.map.mapcenter_lat && @layer.map.mapcenter_lon && @layer.map.zoom

    @layer.mapcenter_lat = @layer.map.mapcenter_lat
    @layer.mapcenter_lon = @layer.map.mapcenter_lon
    @layer.zoom = @layer.map.zoom
  end

  # POST /layers
  # POST /layers.json
  def create
    @layer = Layer.new(layer_params)
    @layer.color = "##{@layer.color}" if @layer.color && !@layer.color.include?('#')
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    respond_to do |format|
      if @layer.save
        format.html { redirect_to map_layer_path(@map, @layer), notice: 'Layer was created.' }
        format.json { render :show, status: :created, location: @layer }
      else
        format.html { render :new }
        format.json { render json: @layer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /layers/1
  # PATCH/PUT /layers/1.json
  def update
    @layer.color = "##{@layer.color}" if @layer.color && !@layer.color.include?('#')
    params[:layer][:exif_remove] = default_checkbox(params[:layer][:exif_remove])
    params[:layer][:rasterize_images] = default_checkbox(params[:layer][:rasterize_images])

    respond_to do |format|
      if @layer.update(layer_params)
        format.html { redirect_to map_layer_path(@map, @layer), notice: 'Layer was successfully updated.' }
        format.json { render :show, status: :ok, location: @layer }
      else
        format.html { render :edit }
        format.json { render json: @layer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /layers/1
  # DELETE /layers/1.json
  def destroy
    @layer.destroy
    respond_to do |format|
      format.html { redirect_to map_path(@map), notice: 'Layer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def build_params
    params.require(:layer).permit(:content, :build)
  end

  def redirect_to_friendly_id
    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    redirect_to map_layer_path(@map, @layer), status: :moved_permanently if @map && @layer && request.path != map_layer_path(@map, @layer) && request.format == 'html'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_layer
    @map = Map.by_user(current_user).find_by_slug(params[:map_id]) || Map.by_user(current_user).find_by_id(params[:map_id])
    @layer = Layer.find_by_slug(params[:id]) || Layer.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def layer_params
    params.require(:layer).permit(:title, :subtitle, :teaser, :text, :credits, :published, :public_submission, :map_id, :color, :background_color, :tooltip_display_mode, :places_sort_order, :basemap_url, :basemap_attribution, :mapcenter_lat, :mapcenter_lon, :zoom, :use_mapcenter_from_parent_map, :image, :backgroundimage, :favicon, :exif_remove, :rasterize_images, :relations_bending, :relations_coloring, :image_alt, :image_licence, :image_source, :image_creator, :image_caption)
  end
end
