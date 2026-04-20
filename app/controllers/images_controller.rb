# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :set_locale
  before_action :set_image, only: %i[show edit update destroy]

  # GET /images
  # GET /images.json
  def index
    redirect_to root_url, notice: 'No place defined for showing this image' if !@place || @place.layer.map.group != current_user.group
    @images = Image.where(place_id: @place_id)
  end

  # GET /images/1
  # GET /images/1.json
  def show
    redirect_to root_url, notice: "You are not allowed for viewing this image #{current_user.group.title}" if @image.place.layer.map.group != current_user.group && current_user.group.title != 'Admins'
  end

  # GET /images/new
  def new
    @image = Image.new
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    if params[:page_id].present?
      @locale = params[:locale]
      @page = Page.friendly.find(params[:page_id])
      redirect_to root_url, notice: 'No page defined for adding an image' unless @page || (@page && @page.map.group == current_user.group)
    else
      @place = Place.find(params[:place_id])
      @layer = @place.layer
      redirect_to root_url, notice: 'No place defined for adding an image' unless @place || (@place && @place.layer.map.group == current_user.group)
    end
  end

  # GET /images/1/edit
  def edit
    if params[:page_id].present?
      @locale = params[:locale]
      @page = @image.page
      redirect_to root_url, notice: 'No valid page defined for editing an mage' unless @page || (@page && @page.layer.map.group == current_user.group)
    else
      @place = @image.place
      redirect_to root_url, notice: 'No valid place defined for editing an mage' unless @place || (@place && @place.layer.map.group == current_user.group)
    end
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    if params[:page_id].present?
      @locale = params[:locale]
      @page = Page.friendly.find(params[:page_id])
    else
      @layer = Layer.friendly.find(params[:layer_id])
      @place = Place.find(params[:place_id])
    end
    puts "image_params: #{image_params.inspect}"
    respond_to do |format|
      if @image.save
        if params[:page_id].present?
          format.html { redirect_to edit_map_page_path(@locale, @image.page.map, @image.page), notice: 'Image was successfully created.' }
        else
          format.html { redirect_to edit_map_layer_place_path(@image.place.layer.map, @image.place.layer, @image.place), notice: 'Image was successfully created.' }
        end
        format.json { render :show, status: :created, location: @image }
      else
        puts "image errors: #{@image.errors.full_messages.join(', ')}"
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    params[:image][:preview] = default_checkbox?(params[:image][:preview])
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to edit_map_layer_place_path(@image.place.layer.map, @image.place.layer, @image.place), notice: 'Image was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to edit_map_layer_place_path(@image.place.layer.map, @image.place.layer, @image.place), notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
    @place = Place.find(params[:place_id])
    @image = Image.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def image_params
    params.require(:image).permit(:title, :licence, :source, :creator, :place_id, :alt, :caption, :sorting, :preview, :file, :itype, :imageable_id, :imageable_type)
  end
end
