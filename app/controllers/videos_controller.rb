# frozen_string_literal: true

class VideosController < ApplicationController
  before_action :set_video, only: %i[show edit update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  # GET /videos
  # GET /videos.json
  def index
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
    @place = Place.find(params[:place_id])
    redirect_to root_url, notice: 'No place defined for showing this video' if !@place || @place.layer.map.group != current_user.group
    @videos = Video.where(videoable_type: 'Place', videoable_id: @place.id)
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    allowed = current_user.group.title == 'Admins' || (@place && @place.layer.map.group == current_user.group && @video.videoable == @place)
    redirect_to root_url, notice: "You are not allowed for viewing this video #{current_user.group.title}" unless allowed
  end

  # GET /videos/new
  def new
    @video = Video.new
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
    @place = Place.find(params[:place_id])
    redirect_to root_url, notice: 'No place defined for adding an video' unless @place || (@place && @place.layer.map.group == current_user.group)
  end

  # GET /videos/1/edit
  def edit
    @place = @video.videoable
    redirect_to root_url, notice: 'No valid place defined for editing an mage' unless @place || (@place && @place.layer.map.group == current_user.group)
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
    @place = Place.find(params[:place_id])
    @video.videoable ||= @place
    respond_to do |format|
      if @video.save
        format.html { redirect_to edit_map_layer_place_path(@video.videoable.layer.map, @video.videoable.layer, @video.videoable), notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to edit_map_layer_place_path(@video.videoable.layer.map, @video.videoable.layer, @video.videoable), notice: 'Video was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to edit_map_layer_place_path(@video.videoable.layer.map, @video.videoable.layer, @video.videoable), notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_video
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
    @place = Place.find(params[:place_id])
    @video = Video.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def video_params
    params.require(:video).permit(:title, :licence, :source, :creator, :alt, :caption, :sorting, :preview, :file, :videoable_type, :videoable_id)
  end

  def handle_record_not_found
    redirect_to root_url, alert: 'Resource not found'
  end
end
