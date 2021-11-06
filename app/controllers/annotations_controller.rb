# frozen_string_literal: true

class AnnotationsController < ApplicationController
  before_action :set_annotation, only: %i[show edit update destroy]

  # GET /annotation or /annotation.json
  def index
    @annotation = Annotation.all
  end

  def new
    @annotation = Annotation.new
    @annotation.place_id = params[:place_id]
    @annotations = Annotation.all
  end

  def edit
    @annotations = Annotation.all
  end

  def create
    @annotation = Annotation.new(annotation_params)
    @annotations = Annotation.all

    respond_to do |format|
      if @annotation.save
        if params[:back_to] == 'edit'
          format.html { redirect_to edit_map_layer_place_path(@annotation.place.layer.map,@annotation.place.layer,@annotation.place), notice: 'Annotation was successfully created.' }
        else
          format.html { redirect_to map_layer_place_path(@annotation.place.layer.map,@annotation.place.layer,@annotation.place), notice: 'Annotation was successfully created.' }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /annotation/1 or /annotation/1.json
  def update
    @annotations = Annotation.all
    respond_to do |format|
      if @annotation.update(annotation_params)
        if params[:back_to] == 'edit'
          format.html { redirect_to edit_map_layer_place_path(@annotation.place.layer.map,@annotation.place.layer,@annotation.place), notice: 'Annotation was successfully updated.' }
        else
          format.html { redirect_to map_layer_place_path(@annotation.place.layer.map,@annotation.place.layer,@annotation.place), notice: 'Annotation was successfully updated.' }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @annotation.destroy
    respond_to do |format|
      if params[:back_to] == 'edit'
        format.html { redirect_to edit_map_layer_place_path(@annotation.place.layer.map,@annotation.place.layer,@annotation.place), notice: 'Annotation was successfully updated.' }
      else
        format.html { redirect_to map_layer_place_path(@annotation.place.layer.map,@annotation.place.layer,@annotation.place), notice: 'Annotation was successfully updated.' }
      end
    end
  end

  private

  def set_annotation
    @annotation = Annotation.find(params[:id])
  end

  def annotation_params
    params.require(:annotation).permit(:title, :text, :annotation_id, :source, :place_id, :person_id, tag_list: [] )
  end
end
