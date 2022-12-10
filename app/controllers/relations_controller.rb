# frozen_string_literal: true

class RelationsController < ApplicationController
  before_action :set_relation, only: %i[edit update destroy]

  # GET /relations or /relations.json
  def index
    @relations = Relation.all
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    redirect_to maps_path, notice: 'Sorry, this map could not be found.' and return unless @map

    @layers = @map.layers
  end

  # GET /relations/new
  def new
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    if params[:layer_id]
      @layer = Layer.find(params[:layer_id])
      @layers_from = [@layer]
    else
      @layers_from = @map.layers
    end
    @layers_to = @map.layers
    @relation = Relation.new
    @relation.relation_from = Place.find(params[:relations_from_id]) if params[:relations_from_id]
  end

  # GET /relations/1/edit
  def edit; end

  # POST /relations
  def create
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layers_from = @map.layers
    @layers_to = @map.layers
    @relation = Relation.new(relation_params)
    # @layer = @relation.relation_from ? @relation.relation_from.layer : nil
    @layer = @relation.relation_from.layer if @relation.relation_from&.layer

    respond_to do |format|
      if @relation.save
        case params[:back]
        when 'place'
          format.html { redirect_to map_layer_place_path(@map, @layer, @relation.relation_from_id), notice: 'Relation was successfully created.' }
        when 'layer'
          format.html { redirect_to relations_map_layer_path(@map, @layer), notice: 'Relation was successfully created.' }
        else
          format.html { redirect_to map_relations_path(@map), notice: 'Relation was successfully created.' }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /relations/1 or /relations/1.json
  def update
    respond_to do |format|
      if @relation.update(relation_params)
        format.html { redirect_to map_relations_path(@map), notice: 'Relation was successfully updated.' }
        format.json { render :show, status: :ok, location: @relation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relations/1 or /relations/1.json
  def destroy
    @relation.destroy
    respond_to do |format|
      format.html { redirect_to map_relations_path(@map), notice: 'Relation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_relation
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    if @map
      @layers_from = @map.layers
      @layers_to = @map.layers
      @layers = @map.layers
      layers_ids = @layers.pluck(:id)
      @all_places = Place.where(layer: layers_ids)
      @relation = Relation.find(params[:id])
    else

      redirect_to notfound_url
    end
  end

  # Only allow a list of trusted parameters through.
  def relation_params
    params.require(:relation).permit(:relation_from_id, :relation_to_id, :rtype)
  end
end
