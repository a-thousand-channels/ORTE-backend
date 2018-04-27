class IconsetsController < ApplicationController
  before_action :set_iconset, only: [:show, :edit, :update, :destroy]

  # GET /iconsets
  # GET /iconsets.json
  def index
    @iconsets = Iconset.all
  end

  # GET /iconsets/1
  # GET /iconsets/1.json
  def show
  end

  # GET /iconsets/new
  def new
    @iconset = Iconset.new
  end

  # GET /iconsets/1/edit
  def edit
  end

  # POST /iconsets
  # POST /iconsets.json
  def create
    @iconset = Iconset.new(iconset_params)

    respond_to do |format|
      if @iconset.save
        format.html { redirect_to @iconset, notice: 'Iconset was successfully created.' }
        format.json { render :show, status: :created, location: @iconset }
      else
        format.html { render :new }
        format.json { render json: @iconset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /iconsets/1
  # PATCH/PUT /iconsets/1.json
  def update
    respond_to do |format|
      if @iconset.update(iconset_params)
        format.html { redirect_to @iconset, notice: 'Iconset was successfully updated.' }
        format.json { render :show, status: :ok, location: @iconset }
      else
        format.html { render :edit }
        format.json { render json: @iconset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /iconsets/1
  # DELETE /iconsets/1.json
  def destroy
    @iconset.destroy
    respond_to do |format|
      format.html { redirect_to iconsets_url, notice: 'Iconset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iconset
      @iconset = Iconset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def iconset_params
      params.require(:iconset).permit(:title, :text, :image)
    end
end
