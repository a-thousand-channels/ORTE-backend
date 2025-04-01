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
  end

  def create
    @import_mapping = ImportMapping.new(import_mapping_params)

    if @import_mapping.save
      redirect_to @import_mapping
    else
      render :new
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
