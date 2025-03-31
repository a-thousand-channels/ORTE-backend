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

      @places = @map_layers.flat_map(&:places)
      puts "places: #{@places.count}"
      if params[:map]
        puts '------------------------'
        puts "search params: #{params[:map][:search]}"
        @search = params[:map][:search]
        @places = @map.places.where('places.title LIKE :query OR places.teaser LIKE :query OR places.text LIKE :query', query: "%#{@search}%")
        puts "places: #{@places.count}"
      end
      if params[:tag_id] && !params[:tag_id].empty?
        puts "tag_data: #{params[:tag_id]}"
        puts '------------------------'
        @tag = ActsAsTaggableOn::Tag.find(params[:tag_id])
        puts "tag: #{@tag.name}"
        @places = Place.tagged_with(@tag.name) if @tag
        puts "places: #{@places.count}"
      end

      @places_with_dates = @places.reject { |place| place.startdate.nil? && place.enddate.nil? }

      # timeline calculation, for now on a yearly basis
      @minyear = @places.reject { |place| place.startdate.nil? }.min_by { |place| place.startdate.year }&.startdate&.year || Date.today.year
      @maxyear = @places.reject { |place| place.enddate.nil? }.max_by { |place| place.enddate.year }&.enddate&.year || Date.today.year

      # make a hash, where the key is a single year and it contains all places that are active in that year
      @places_by_year = {}
      @places_with_dates.each do |place|
        startyear = place.startdate.nil? ? @minyear : place.startdate.year
        endyear = place.enddate.nil? ? startyear : place.enddate.year
        (startyear..endyear).each do |year|
          @places_by_year[year.to_i] ||= []
          @places_by_year[year.to_i] << place
        end
      end
      @timespan = @maxyear - @minyear

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
    params.require(:map).permit(:title, :subtitle, :text, :credits, :published, :script, :image, :group_id, :mapcenter_lat, :mapcenter_lon, :zoom, :northeast_corner, :southwest_corner, :iconset_id, :basemap_url, :basemap_attribution, :background_color, :popup_display_mode, :marker_display_mode, :show_annotations_on_map, :preview_url, :enable_privacy_features, :enable_map_to_go, :enable_historical_maps, :enable_time_slider)
  end
end
