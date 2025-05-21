# frozen_string_literal: true

require 'csv'

class ImportMappingsController < ApplicationController
  before_action :assign_from_params, only: %i[new create show apply_mapping import_preview]
  before_action :set_import_mapping, only: %i[show apply_mapping import_preview]

  def new
    @missing_fields = params[:missing_fields]
    @headers = params[:headers].compact.reject(&:empty?)
    @place_columns = Place.column_names + ['tag_list']
    @import_mapping = ImportMapping.from_header(@headers)
    @existing_mappings = matching_import_mappings(@headers)
  end

  def create
    mapping = JSON.parse(params[:import_mapping][:mapping])
    @import_mapping = ImportMapping.new(name: params[:import_mapping][:name], mapping: mapping)
    @headers = JSON.parse(params[:headers])
    layer_id = @layer&.id

    if @import_mapping.save
      redirect_to import_mapping_path(@import_mapping, layer_id: layer_id, map_id: @map.id, file_name: @file_name, col_sep: @col_sep, quote_char: @quote_char), notice: 'Import mapping was successfully created.'
    else
      @place_columns = Place.column_names + ['tag_list']
      render :new, missing_fields: @import_mapping.errors[:mapping], headers: @headers
    end
  end

  def show
    @import_mapping = ImportMapping.find(params[:id])
    @maps = Map.all
    @layers = Layer.all
  end

  def apply_mapping
    csv_file = handle_file_upload
    return redirect_to import_mapping_path(@import_mapping), alert: 'Please upload a CSV file.' unless csv_file

    # require either a mapping for the model property layer_id or a fixed layer_id for the entire import
    return redirect_to import_mapping_path(@import_mapping), alert: 'Please select a layer' if !@import_mapping&.mapping&.any? { |m| m['model_property'] == 'layer_id' } && !@layer

    unless mapping_matches_file?
      flash[:error] = 'CSV is not matching mapping. Please select or create another mapping.'
      return redirect_to new_import_mapping_path(headers: @headers, missing_fields: @missing_fields, layer_id: @layer_id, file_name: @original_filename, col_sep: @col_sep, quote_char: @quote_char)
    end

    prepare_import(csv_file)

    flash[:notice] = 'CSV read successfully!'
    redirect_to import_preview_import_mapping_path(
      @import_mapping,
      overwrite: @overwrite,
      file_name: @file_name,
      layer_id: @layer_id,
      map_id: @map_id
    )
  rescue CSV::MalformedCSVError => e
    flash[:error] = "Malformed CSV: #{e.message} (Maybe the file does not contain CSV or has another column separator?)"
    redirect_to import_mapping_path(@import_mapping, layer_id: @layer_id, map_id: @map_id)
  end

  def import_preview
    not_importing_rows = ImportContextHelper.read_not_importing_rows(@file_name)
    @duplicate_rows = not_importing_rows[:duplicate_rows]
    @errored_rows = not_importing_rows[:errored_rows]
    @ambiguous_rows = not_importing_rows[:ambiguous_rows]
    @invalid_duplicate_rows = not_importing_rows[:invalid_duplicate_rows]
    @valid_rows = ImportContextHelper.read_importing_rows(@file_name)
    @importing_duplicate_rows = ImportContextHelper.read_importing_duplicate_rows(@file_name)
    @places_to_be_overwritten = []
    @overwrite = params[:overwrite] == '1'
    return unless @overwrite

    @duplicate_rows&.each do |row|
      existing_place = Place.find(row[:duplicate_id])
      @places_to_be_overwritten << existing_place if existing_place
    end
  end

  private

  def matching_import_mappings(headers)
    headers = headers.compact.reject(&:empty?)
    ImportMapping.all.select do |mapping|
      mapping.mapping.all? { |m| headers.include?(m['csv_column_name']) }
    end
    # TODO: auch mappings ohne layer_id werden angezeigt
  end

  def import_mapping_params
    params.require(:import_mapping).permit(:name, :mapping)
  end

  def assign_from_params
    @file_name = params[:file_name]
    @quote_char = params[:quote_char]
    @col_sep = params[:col_sep]
    @layer = Layer.find(params[:layer_id]) if params[:layer_id].present?
    @layer_id = @layer&.id
    @map = @layer&.map || Map.find_by(id: params[:map_id])
    @map_id = @map&.id
  end

  def set_import_mapping
    @import_mapping = ImportMapping.find(params[:id])
  end

  def handle_file_upload
    if @file_name.present?
      file_path = ImportContextHelper.read_tempfile_path(@file_name)
      return File.open(file_path) if file_path

      return nil
    end

    @file = params[:import][:file]
    return unless @file

    @original_filename = @file.original_filename
    temp_file_path = Rails.root.join('tmp', File.basename(@original_filename))
    File.binwrite(temp_file_path, @file.read)
    ImportContextHelper.write_tempfile_path(@file, temp_file_path)
    @file_name = File.basename(@file.original_filename)

    set_csv_options
    File.open(ImportContextHelper.read_tempfile_path(@file_name))
  end

  def mapping_matches_file?
    @headers = CSV.read(ImportContextHelper.read_tempfile_path(@file_name), headers: true, col_sep: @col_sep, quote_char: @quote_char).headers
    matching_mappings = matching_import_mappings(@headers)
    return true if matching_mappings.include? @import_mapping

    importer = Imports::MappingCsvImporter.new(@file, @layer.id, @map.id, ImportMapping.new, col_sep: @col_sep, quote_char: @quote_char)
    importer.import
    @missing_fields = importer.missing_fields
    false
  end

  def set_csv_options
    column_separator = params[:import][:column_separator] || ','
    @col_sep = case column_separator
               when 'Comma' then ','
               when 'Semicolon' then ';'
               when 'Tab' then "\t"
               else ','
               end
    @quote_char = params[:import][:quote_char] || '"'
  end

  def prepare_import(csv_file)
    @overwrite = params[:import][:overwrite]
    importer = Imports::MappingCsvImporter.new(csv_file, @layer&.id, @map.id, @import_mapping, overwrite: @overwrite, col_sep: @col_sep, quote_char: @quote_char)
    importer.import

    @valid_rows = importer.valid_rows
    @errored_rows = importer.errored_rows
    @duplicate_rows = importer.duplicate_rows
    @invalid_duplicate_rows = importer.invalid_duplicate_rows
    @ambiguous_rows = importer.ambiguous_rows
    @importing_duplicate_rows = @overwrite == '1' ? @duplicate_rows.map { |row| row[:place] } : []

    ImportContextHelper.write_not_importing_rows(@file_name, {
                                                   errored_rows: @errored_rows,
                                                   duplicate_rows: @duplicate_rows,
                                                   ambiguous_rows: @ambiguous_rows,
                                                   invalid_duplicate_rows: @invalid_duplicate_rows
                                                 })
    ImportContextHelper.write_importing_rows(@file_name, @valid_rows)
    ImportContextHelper.write_importing_duplicate_rows(@file_name, @importing_duplicate_rows)
  end
end
