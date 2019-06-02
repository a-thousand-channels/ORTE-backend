class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  # GET /places
  # GET /places.json
  def index
    @layer = Layer.find(params[:layer_id])
    @map = @layer.map
    @places = @layer.places
  end

  # GET /places/1
  # GET /places/1.json
  def show
  end

  # GET /places/new
  def new
    @place = Place.new
    @place.location = params[:location]
    @place.address = params[:address]
    @place.zip = params[:zip]
    @place.city = params[:city]
    @place.lat = params[:lat]
    @place.lon = params[:lon]
    @place.layer_id = params[:layer_id]
    @map = Map.by_user(current_user).find(params[:map_id])
    @layer = Layer.find(params[:layer_id])
  end

  # GET /places/1/edit
  def edit

    if @place.startdate
      @place.startdate_date = @place.startdate.to_date
      @place.startdate_time = @place.startdate.to_time
    end

    if @place.enddate
      @place.enddate_date = @place.enddate.to_date
      @place.enddate_time = @place.enddate.to_time
    end

    if params[:lat].present?
      flash[:notice] = "Re-Map: Got new coordinates and address data. Please check all fields and click 'Update place'"
      @old_place = @place.dup
      @place.location = params[:location]
      @place.address = params[:address]
      @place.zip = params[:zip]
      @place.city = params[:city]
      @place.lat = params[:lat]
      @place.lon = params[:lon]
      @place.layer_id = params[:layer_id]
      @map = Map.by_user(current_user).find(params[:map_id])
      @layer = Layer.find(params[:layer_id])
    end
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params)
    @layer = Layer.find(@place.layer_id)
    @map = @layer.map

    respond_to do |format|
      if @place.save
        format.html { redirect_to map_layer_url(@map,@layer), notice: 'Place was successfully created.' }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    @layer = @place.layer
    @map = @place.layer.map

    # quirks, because foundation switch generats 'on'/'off' values,
    # rails expect true/false
    # TODO: render this at generating the form
    puts params[:place][:published]
    if params[:place][:published] == 'on' || params[:place][:published] == 'true'
      params[:place][:published] = true
    else
      params[:place][:published] = false
    end
    params[:place][:published]
    respond_to do |format|
      if @place.update(place_params)
        @place.update({"published"=>params[:place][:published]})
        format.html { redirect_to map_layer_url(@map.id,@place.layer.id), notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to map_layer_places_path(@map,@layer), notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @map = Map.by_user(current_user).find(params[:map_id])
      @layer = Layer.find(params[:layer_id])
      @place = Place.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit(:title, :teaser, :text, :link, :startdate, :startdate_date, :startdate_time, :enddate, :enddate_date, :enddate_time, :lat, :lon, :location, :address, :zip, :city, :country, :published, :imagelink, :layer_id, images: [])
    end
end
