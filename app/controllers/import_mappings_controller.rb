# frozen_string_literal: true

class ImportMappingsController < ApplicationController
  def new
    @missing_fields = params[:missing_fields]
    @headers = params[:headers]
    @layer = Layer.find(params[:layer_id])
    @place_columns = Place.column_names + ['tag_list']
    @import_mapping = ImportMapping.from_header(@headers)
    @existing_mappings = matching_import_mappings(@headers)
    @file_name = params[:file_name]
    @quote_char = params[:quote_char]
    @col_sep = params[:col_sep]
  end

  def create
    mapping = JSON.parse(params[:import_mapping][:mapping])
    @import_mapping = ImportMapping.new(name: params[:import_mapping][:name], mapping: mapping)
    @headers = JSON.parse(params[:headers])
    @layer = Layer.find(params[:layer_id]) if params[:layer_id].present?
    @file_name = params[:file_name]
    @quote_char = params[:quote_char]
    @col_sep = params[:col_sep]

    respond_to do |format|
      if @import_mapping.save
        format.html { redirect_to import_mapping_path(@import_mapping, layer_id: @layer.id, file_name: @file_name, col_sep: @col_sep, quote_char: @quote_char), notice: 'Import mapping was successfully created.' }
        format.json { render :show, status: :created, location: @import_mapping }
      else
        format.html { render :new, missing_fields: @import_mapping.errors[:mapping], headers: @headers }
        format.json { render json: @import_mapping.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @import_mapping = ImportMapping.find(params[:id])
    @maps = Map.all
    @layers = Layer.all
    @layer = Layer.find(params[:layer_id]) if params[:layer_id].present?
    @map = @layer&.map
    @file_name = params[:file_name]
    @quote_char = params[:quote_char]
    @col_sep = params[:col_sep]
    ImportContextHelper.read_tempfile_path(@file_name)
  end

  def apply_mapping
    @import_mapping = ImportMapping.find(params[:id])
    @map = Map.find(params[:import][:map_id])
    @layer = @map.layers.find(params[:import][:layer_id])
    @file_name = params[:file_name]
    @quote_char = params[:quote_char]
    @col_sep = params[:col_sep]
    file_path = ImportContextHelper.read_tempfile_path(@file_name)
    csv_file = File.open(file_path)
    @overwrite = params[:import][:overwrite]

    if csv_file.present?
      importer = Imports::MappingCsvImporter.new(csv_file, @layer.id, @import_mapping, overwrite: @overwrite, col_sep: @col_sep, quote_char: @quote_char)
      importer.import
      flash[:notice] = 'CSV read successfully!'
      @valid_rows = importer.valid_rows
      @errored_rows = importer.errored_rows
      @duplicate_rows = importer.duplicate_rows
      @invalid_duplicate_rows = importer.invalid_duplicate_rows
      @ambiguous_rows = importer.ambiguous_rows
      @importing_duplicate_rows = []
      if @overwrite == '1'
        @duplicate_rows.each do |row|
          @importing_duplicate_rows << row[:place]
        end
      end
      ImportContextHelper.write_importing_rows(@file_name, @valid_rows)
      ImportContextHelper.write_importing_duplicate_rows(@file_name, @importing_duplicate_rows)
      redirect_to import_preview_import_mapping_path(@import_mapping, overwrite: @overwrite, errored_rows: @errored_rows, duplicate_rows: @duplicate_rows, ambiguous_rows: @ambiguous_rows, invalid_duplicate_rows: @invalid_duplicate_rows, file_name: @file_name, layer_id: @layer.id, map_id: @map.id)
    else
      redirect_to import_mapping_path(@import_mapping), alert: 'Please upload a CSV file.'
    end
  end

  def import_preview
    @file_name = params[:file_name]
    @import_mapping = ImportMapping.find(params[:id])
    @valid_rows = ImportContextHelper.read_importing_rows(@file_name)
    @duplicate_rows = params[:duplicate_rows]
    @importing_duplicate_rows = ImportContextHelper.read_importing_duplicate_rows(@file_name)
    @ambiguous_rows = params[:ambiguous_rows]
    @errored_rows = params[:errored_rows]
    @invalid_duplicate_rows = params[:invalid_duplicate_rows]
    @layer = Layer.find(params[:layer_id])
    @map = Map.find(params[:map_id])
    @quote_char = params[:quote_char]
    @col_sep = params[:col_sep]
    @overwrite = params[:overwrite] == '1'
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
