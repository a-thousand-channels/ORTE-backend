# frozen_string_literal: true

class LayersController < ApplicationController
  before_action :set_layer, only: %i[images show edit update destroy]

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

  # GET /layers/1
  # GET /layers/1.json
  def show
    @maps = Map.sorted.by_user(current_user)
    if @map
      @map_layers = @map.layers
    else
      redirect_to maps_path, notice: "Sorry, this map could not be found." and return
    end

    if @layer
      @places = @layer.places
      @place = Place.find(params[:place_id]) if params[:remap]
      respond_to do |format|
        format.html { render :show }
        format.json { render :show }
        format.csv { send_data @places.to_csv, filename: "orte-map-#{@layer.map.title.parameterize}-layer-#{@layer.title.parameterize}-#{I18n.l Date.today}.csv" }
      end
    else
      redirect_to maps_path, notice: "Sorry, this layer could not be found."
    end
  end

  # GET /layers/new
  def new
    @layer = Layer.new
    generator = ColorGenerator.new saturation: 0.7, lightness: 0.75
    @layer.color = "##{generator.create_hex}"
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @colors_selectable = []
    6.times do
      @colors_selectable << "##{generator.create_hex}"
    end
  end

  # GET /layers/1/edit
  def edit
    generator = ColorGenerator.new saturation: 0.7, lightness: 0.75
    if !@layer.color || params[:recolor]
      @layer.color = "##{generator.create_hex}"
    elsif @layer.color && !@layer.color.include?('#')
      @layer.color = "##{@layer.color}"
    end

    @colors_selectable = []
    6.times do
      @colors_selectable << "##{generator.create_hex}"
    end
  end

  # POST /layers
  # POST /layers.json
  def create
    @layer = Layer.new(layer_params)
    @layer.color = "##{@layer.color}" if @layer.color && !@layer.color.include?('#')
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    respond_to do |format|
      if @layer.save
        format.html { redirect_to map_path(@map), notice: 'Layer was created.' }
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
    respond_to do |format|
      if @layer.update(layer_params)
        format.html { redirect_to map_path(@map), notice: 'Layer was successfully updated.' }
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

  def redirect_to_friendly_id

    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    if @map && @layer && request.path != map_layer_path(@map,@layer) && request.format == 'html'
      return redirect_to map_layer_path(@map, @layer), :status => :moved_permanently
    end
  end


  # Use callbacks to share common setup or constraints between actions.
  def set_layer
    @map = Map.by_user(current_user).find_by_slug(params[:map_id]) || Map.by_user(current_user).find_by_id(params[:map_id])
    @layer = Layer.find_by_slug(params[:id]) || Layer.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def layer_params
    params.require(:layer).permit(:title, :subtitle, :text, :published, :public_submission, :map_id, :color)
  end
end
