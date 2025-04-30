# frozen_string_literal: true

class ImportMappingsController < ApplicationController
  def index
    @import_mappings = ImportMapping.all
  end

  def show
    @import_mapping = ImportMapping.find(params[:id])
    @maps = Map.all
    @layers = Layer.all
    @layer = Layer.find(session[:layer_id]) if session[:layer_id].present?
    @map = @layer.map
    @temp_file_path = session[:temp_file_path]
    @file_name = session[:file_name]
  end

  def import_preview
    @import_mapping = ImportMapping.find(params[:id])
    @valid_rows = session.delete(:valid_rows) # Retrieve and clear from session
    @invalid_rows = params[:invalid_rows]
    @layer = Layer.find(params[:layer_id])
    @map = Map.find(params[:map_id])
  end

  def new
    @missing_fields = params[:missing_fields]
    @headers = params[:headers]
    @place_columns = Place.column_names + ['tag_list']
    @import_mapping = ImportMapping.from_header(@headers)
    @existing_mappings = matching_import_mappings(@headers)
  end

  def create
    mapping = JSON.parse(params[:import_mapping][:mapping])
    @import_mapping = ImportMapping.new(name: params[:import_mapping][:name], mapping: mapping)
    @headers = JSON.parse(params[:import_mapping][:headers])

    respond_to do |format|
      if @import_mapping.save
        format.html { redirect_to @import_mapping, notice: 'Import mapping was successfully created.' }
        format.json { render :show, status: :created, location: @import_mapping }
      else
        format.html { render :new, missing_fields: @import_mapping.errors[:mapping], headers: @headers }
        format.json { render json: @import_mapping.errors, status: :unprocessable_entity }
      end
    end
  end

  def apply_mapping
    @import_mapping = ImportMapping.find(params[:id])
    @map = Map.find(params[:import][:map_id])
    @layer = @map.layers.find(params[:import][:layer_id])

    csv_file = if params[:import][:file].present?
                 params[:import][:file]
               elsif session[:temp_file_path].present? && File.exist?(session[:temp_file_path])
                 File.open(session[:temp_file_path])
               end

    overwrite = params[:import][:overwrite] # Todo!

    if csv_file.present?
      importer = Imports::MappingCsvImporter.new(csv_file, @layer.id, @import_mapping)
      importer.import
      flash[:notice] = 'CSV read successfully!'
      @valid_rows = importer.valid_rows
      session[:importing_rows] = @valid_rows
      session[:valid_rows] = @valid_rows
      redirect_to import_preview_import_mapping_path(@import_mapping, invalid_rows: importer.invalid_rows, layer_id: @layer.id, map_id: @map.id)
    else
      redirect_to import_mapping_path(@import_mapping), alert: 'Please upload a CSV file.'
    end
  end

  def edit
    @import_mapping = ImportMapping.find(params[:id])
  end

  def update
    @import_mapping = ImportMapping.find(params[:id])

    if @import_mapping.update(import_mapping_params)
      redirect_to @import_mapping
    else
      render :edit
    end
  end

  def destroy
    @import_mapping = ImportMapping.find(params[:id])
    @import_mapping.destroy

    redirect_to import_mappings_path
  end

  private

  def matching_import_mappings(headers)
    ImportMapping.all.select do |mapping|
      mapping.mapping.all? { |m| headers.include?(m['csv_column_name']) }
    end
  end

  def import_mapping_params
    params.require(:import_mapping).permit(:name, :mapping)
  end
end
