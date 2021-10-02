# frozen_string_literal: true

class SubmissionConfigsController < ApplicationController
  before_action :set_submission_config, only: %i[show edit update destroy]
  before_action :switch_config_locale

  def switch_config_locale
    locale = extract_locale || Mobility.locale
    Mobility.locale = locale
    @locale_mobility = locale
  end

  def extract_locale
    parsed_locale = params[:locale_mobility]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  # GET /submission_configs or /submission_configs.json
  def index
    @submission_configs = SubmissionConfig.all
  end

  # GET /submission_configs/1 or /submission_configs/1.json
  def show; end

  # GET /submission_configs/new
  def new
    @submission_config = SubmissionConfig.new
    @layer = Layer.find(layer_from_id)
  end

  # GET /submission_configs/1/edit
  def edit
    @layer = Layer.find(@submission_config.layer_id)
  end

  # POST /submission_configs or /submission_configs.json
  def create
    @submission_config = SubmissionConfig.new(submission_config_params)
    @layer = Layer.find_by_id(@submission_config.layer_id)
    @map = @layer.map

    respond_to do |format|
      if @submission_config.save
        format.html { redirect_to edit_map_layer_path(@map.id, @layer.id), notice: 'Submission config was successfully created.' }
        format.json { render :show, status: :created, location: @submission_config }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @submission_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submission_configs/1 or /submission_configs/1.json
  def update
    respond_to do |format|
      if @submission_config.update(submission_config_params)
        format.html { redirect_to edit_map_layer_path(@map.id, @layer.id), notice: 'Submission config was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission_config }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @submission_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submission_configs/1 or /submission_configs/1.json
  def destroy
    @submission_config.destroy
    respond_to do |format|
      format.html { redirect_to submission_configs_url, notice: 'Submission config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def layer_from_id
    params[:layer_id].to_i
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_submission_config
    @submission_config = SubmissionConfig.find(params[:id])
    @layer = Layer.find_by_id(@submission_config.layer_id)
    @map = @layer.map
  end

  # Only allow a list of trusted parameters through.
  def submission_config_params
    params.require(:submission_config).permit(:title_intro, :subtitle_intro, :intro, :title_outro, :outro, :start_time, :end_time, :use_city_only, :layer_id, locales: [])
  end
end
