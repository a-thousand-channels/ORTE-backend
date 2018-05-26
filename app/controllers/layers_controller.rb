class LayersController < ApplicationController
  before_action :set_layer, only: [:show, :edit, :update, :destroy]

  protect_from_forgery :except => :show

  # GET /layers
  # GET /layers.json
  def index
    @map = Map.find(params[:map_id])
    @layers = @map.layers
  end

  # GET /layers/1
  # GET /layers/1.json
  def show
    @maps = Map.all
    @map_layers = @map.layers
    @places =  @layer.places
    if params[:remap]
      @place = Place.find(params[:place])
    end
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @layer.to_json(:include => { :places => { :methods => [:date, :edit_link] }} ) }
    end
  end

  # GET /layers/new
  def new
    @layer = Layer.new
    @map = Map.find(params[:map_id])
  end

  # GET /layers/1/edit
  def edit
  end

  # POST /layers
  # POST /layers.json
  def create
    @layer = Layer.new(layer_params)
    @map = Map.find(params[:map_id])
    respond_to do |format|
      if @layer.save
        format.html { redirect_to map_path(@map), notice: 'Layer was successfully created.' }
        format.json { render :show, status: :created, location: @layer }
      else
        format.html { render :new }
        format.json { render json: @layer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /layers/1
  # PATCH/PUT /layers/1.json
  def update
    respond_to do |format|
      if @layer.update(layer_params)
        format.html { redirect_to map_path(@map), notice: 'Layer was successfully updated.' }
        format.json { render :show, status: :ok, location: @layer }
      else
        format.html { render :edit }
        format.json { render json: @layer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /layers/1
  # DELETE /layers/1.json
  def destroy
    @layer.destroy
    respond_to do |format|
      format.html { redirect_to map_path(@map), notice: 'Layer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_layer
      @map = Map.find(params[:map_id])
      @layer = Layer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def layer_params
      params.require(:layer).permit(:title, :text, :published, :map_id)
    end
end
