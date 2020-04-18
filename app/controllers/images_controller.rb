class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    unless params[:place_id]
      redirect_to root_url, notice: 'Sorry, no place defined for showing this image'
    end       
    @place = Place.where(id: params[:place_id])
    unless @place || ( @place && @place.layer.map.group == current_user.group )
      redirect_to root_url, notice: 'No place defined for showing this image'
    end  
    @images = Image.where(place_id: @place_id)
  end

  def transition
    @places = Place.all
    # This joins statement returns all Places with an attachement,  "Place.with_attached_images" just counts all places!
    @places_images = Place.joins(:images_attachments)
    @images_file = Image.joins(:file_attachment)
  end


  # GET /images/1
  # GET /images/1.json
  def show
    unless @image.place.layer.map.group == current_user.group
      redirect_to root_url, notice: 'No place defined for showing this image'
    end    
  end

  # GET /images/new
  def new
    @image = Image.new
    @place = Place.where(id: params[:place_id]).first
    unless @place || ( @place && @place.layer.map.group == current_user.group )
      redirect_to root_url, notice: 'No place defined for adding an image'
    end
  end

  # GET /images/1/edit
  def edit

    unless params[:place_id]
      redirect_to root_url, notice: 'No place defined for editing an image'
    end
    @place = Place.where(id: params[:place_id])
    unless @place || ( @place && @place.layer.map.group == current_user.group )
      redirect_to root_url, notice: 'No valid place defined for editing an mage'
    end    
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def image_params
      params.require(:image).permit(:title, :licence, :source, :creator, :place_id, :alt, :caption, :sorting, :preview, :file)
    end
end
