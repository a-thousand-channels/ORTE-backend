# frozen_string_literal: true

class BuildLogsController < ApplicationController
  before_action :set_build_log, only: %i[show edit update destroy]

  # GET /build_logs or /build_logs.json
  def index
    @build_logs = BuildLog.all
  end

  # GET /build_logs/1 or /build_logs/1.json
  def show; end

  # GET /build_logs/1/edit
  def edit; end

  # POST /build_logs or /build_logs.json
  def create
    @build_log = BuildLog.new(build_log_params)

    respond_to do |format|
      if @build_log.save
        format.html { redirect_to @build_log, notice: 'Build log was successfully created.' }
        format.json { render :show, status: :created, location: @build_log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @build_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /build_logs/1 or /build_logs/1.json
  def update
    respond_to do |format|
      if @build_log.update(build_log_params)
        format.html { redirect_to @build_log, notice: 'Build log was successfully updated.' }
        format.json { render :show, status: :ok, location: @build_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @build_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /build_logs/1 or /build_logs/1.json
  def destroy
    @build_log.destroy
    respond_to do |format|
      format.html { redirect_to build_logs_url, notice: 'Build log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_build_log
    @build_log = BuildLog.find(params[:id])
    @map = Map.by_user(current_user).find_by_slug(params[:map_id]) || Map.by_user(current_user).find_by_id(params[:map_id])
    @layer = Layer.find_by_slug(params[:layer_id]) || Layer.find_by_id(params[:layer_id])
  end

  # Only allow a list of trusted parameters through.
  def build_log_params
    params.require(:build_log).permit(:map_id, :layer_id, :output, :size, :version)
  end
end
