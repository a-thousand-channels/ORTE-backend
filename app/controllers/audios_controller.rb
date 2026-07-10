# frozen_string_literal: true

class AudiosController < ApplicationController
  before_action :set_audio, only: %i[show edit update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  # GET /audios
  def index
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
    @place = Place.find(params[:place_id])
    redirect_to root_url, notice: 'No place defined for showing this audio' if !@place || @place.layer.map.group != current_user.group
    @audios = Audio.where(audioable_type: 'Place', audioable_id: @place.id)
  end

  # GET /audios/1
  def show
    allowed = current_user.group.title == 'Admins' || (@place && @place.layer.map.group == current_user.group && @audio.audioable == @place)
    redirect_to root_url, notice: "You are not allowed for viewing this audio #{current_user.group.title}" unless allowed
  end

  # GET /audios/new
  def new
    @audio = Audio.new
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
    @place = Place.find(params[:place_id])
    redirect_to root_url, notice: 'No place defined for adding an audio' unless @place || (@place && @place.layer.map.group == current_user.group)
  end

  # GET /audios/1/edit
  def edit
    @place = @audio.audioable
    redirect_to root_url, notice: 'No valid place defined for editing an audio' unless @place || (@place && @place.layer.map.group == current_user.group)
  end

  # POST /audios
  def create
    @audio = Audio.new(audio_params)
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
    @place = Place.find(params[:place_id])
    @audio.audioable ||= @place
    respond_to do |format|
      if @audio.save
        format.html { redirect_to edit_map_layer_place_path(@audio.audioable.layer.map, @audio.audioable.layer, @audio.audioable), notice: 'Audio was successfully created.' }
        format.json { render :show, status: :created, location: @audio }
      else
        format.html { render :new }
        format.json { render json: @audio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /audios/1
  def update
    respond_to do |format|
      if @audio.update(audio_params)
        format.html { redirect_to edit_map_layer_place_path(@audio.audioable.layer.map, @audio.audioable.layer, @audio.audioable), notice: 'Audio was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /audios/1
  def destroy
    @audio.destroy
    respond_to do |format|
      format.html { redirect_to edit_map_layer_place_path(@audio.audioable.layer.map, @audio.audioable.layer, @audio.audioable), notice: 'Audio was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_audio
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
    @place = Place.find(params[:place_id])
    @audio = Audio.find(params[:id])
  end

  def audio_params
    params.require(:audio).permit(:title, :subtitle, :licence, :source, :creator, :sorting, :preview, :file, :locale, :transcription, :audioable_type, :audioable_id)
  end

  def handle_record_not_found
    redirect_to root_url, alert: 'Resource not found'
  end
end
