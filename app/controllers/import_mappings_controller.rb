# frozen_string_literal: true

class ImportMappingsController < ApplicationController
  def index
    @import_mappings = ImportMapping.all
  end

  def show
    @import_mapping = ImportMapping.find(params[:id])
  end

  def new
    @missing_fields = params[:missing_fields]
    @headers = params[:headers]
    @place_columns = Place.column_names
    @import_mapping = ImportMapping.new
    @existing_mappings = ImportMapping.all.select do |mapping|
      JSON.parse(mapping.mapping).all? { |m| @headers.include?(m['csv_column_name']) }
    end
  end

  def create
    @import_mapping = ImportMapping.new(import_mapping_params)
    @headers = JSON.parse(params[:import_mapping][:headers])
    @place_columns = Place.column_names
    @existing_mappings = ImportMapping.all.select do |mapping|
      JSON.parse(mapping.mapping).all? { |m| @headers.include?(m['csv_column_name']) }
    end

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

  def import_mapping_params
    params.require(:import_mapping).permit(:name, :mapping)
  end
end
