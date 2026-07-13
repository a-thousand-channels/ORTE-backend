# frozen_string_literal: true

class PlacesController < ApplicationController
  before_action :set_place, only: %i[show edit clone edit_clone update_clone update destroy]
  before_action :set_locale
  # GET /places
  # GET /places.json
  def index
    @layer = Layer.friendly.find(params[:layer_id])
    @map = @layer.map
    set_locale
    @places = @layer.places.page params[:page]
  end

  # GET /places/1
  # GET /places/1.json
  def show; end

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
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
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

    return unless params[:lat].present?

    flash[:notice] = "Re-Map: Got new coordinates and address data. Please check all fields and click 'Update place'"
    @old_place = @place.dup
    @place.location = params[:location]
    @place.address = params[:address]
    @place.zip = params[:zip]
    @place.city = params[:city]
    @place.lat = params[:lat]
    @place.lon = params[:lon]
    @place.layer_id = params[:layer_id]
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
  end

  def clone
    @new_place = @place.deep_clone include: [{ images: %i[file_attachment file_blob] }, { videos: %i[file_attachment file_blob filmstill_attachment filmstill_blob] }, :submissions, :annotations]
    @new_place.title = "#{@new_place.title} (Copy)"
    @new_place.published = false

    respond_to do |format|
      if @new_place.save!
        format.html { redirect_to edit_clone_map_layer_place_path(@map, @layer, @new_place), notice: 'Place cloned with all assets, submissions and annotations. Place is automatically set to unpublished' }
      else
        format.html { redirect_to map_layer_places_path(@map, @layer), notice: 'Place could not be copied' }
      end
    end
  end

  def edit_clone
    @maps = Map.by_user(current_user).all
  end

  def update_clone
    respond_to do |format|
      if @place.save!
        format.html { redirect_to edit_map_layer_place_path(@map, @layer, @place), notice: 'Place has been saved.' }
      else
        format.html { redirect_to map_layer_places_path(@map, @layer), notice: 'Place could not be updated' }
      end
    end
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params)
    @layer = Layer.friendly.find(@place.layer_id)
    @map = @layer.map

    respond_to do |format|
      if @place.save
        format.html { redirect_to map_layer_url(@map, @layer), notice: 'Place was successfully created.' }
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

    # TODO: render this at generating the form
    params[:place][:published] = default_checkbox?(params[:place][:published])
    params[:place][:featured] = default_checkbox?(params[:place][:featured])
    params[:place][:sensitive] = default_checkbox?(params[:place][:sensitive])

    saved =
      if params[:locale].present?
        # puts "Updating place with locale #{params[:locale]}"
        Mobility.with_locale(params[:locale]) do
          result = @place.update(place_params_localized)

          # disabled for now, i want a more defensive way working with translatations
          # sync_legacy_fields! if result && default_locale?(params[:locale])
          result
        end
      else
        # puts 'Updating place without locale'
        @place.update(place_params)
      end
    @place.update({ 'published' => params[:place][:published] })

    respond_to do |format|
      if saved
        format.html { redirect_to map_layer_url(@map.id, @place.layer.id), notice: "#{view_context.link_to(@place.title, map_layer_place_path(@map, @layer, @place))} was successfully updated." }
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
      format.html { redirect_to map_layer_places_path(@map, @layer), notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_image_attachment
    @image = ActiveStorage::Blob.find_signed(params[:signed_id])
    @image.attachments.first.purge
    redirect_to transition_path, notice: 'Image attachement has been purged'
  end

  def sort
    @image_ids = params[:images]
    n = 1
    ActiveRecord::Base.transaction do
      @image_ids.each do |dom_id|
        # dom_id is like "image_20"
        id = dom_id.gsub('image_', '')
        image = Image.find(id)
        image.sorting = n
        n += 1
        image.save
      end
    end
    render json: {}
  end

  private

  def set_locale
    I18n.locale = params[:locale] || @map&.primary_language || I18n.default_locale
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_place
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
    @place = Place.find(params[:id])
  end

  def default_locale?(locale)
    locale.to_s == I18n.default_locale.to_s
  end

  # if default_locale update the legacy fields
  def sync_legacy_fields!
    @place.update_columns(
      title: @place.localized_title,
      subtitle: @place.localized_subtitle,
      teaser: @place.localized_teaser,
      text: @place.localized_text,
      sources: @place.localized_sources,
      updated_at: Time.current
    )
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def place_params
    params.require(:place).permit(:title, :uid, :subtitle, :teaser, :text, :sources, :link, :startdate, :startdate_date, :startdate_time, :startdate_qualifier, :enddate, :enddate_date, :enddate_time, :enddate_qualifier, :lat, :lon, :direction, :location, :address, :zip, :city, :country, :published, :featured, :sensitive, :sensitive_radius, :shy, :imagelink, :layer_id, :icon_id, :relations_tos, :relations_froms, :locale, annotations_attributes: %i[title text person_id source], tag_list: [], images: [], videos: [])
  end

  def place_params_localized
    params.require(:place).permit(:startdate, :startdate_date, :startdate_time, :enddate, :enddate_date, :enddate_time, :published, :featured, :sensitive, :lat, :lon, :layer_id, annotations_attributes: %i[title text person_id source], tag_list: [], images: [], videos: []).merge(
      localized_title: params[:place][:localized_title],
      localized_subtitle: params[:place][:localized_subtitle],
      localized_teaser: params[:place][:localized_teaser],
      localized_text: params[:place][:localized_text],
      localized_sources: params[:place][:localized_sources]
    )
  end
end
