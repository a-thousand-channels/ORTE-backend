# frozen_string_literal: true

class Public::SubmissionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index new create edit update new_place create_place edit_place update_place new_image create_image finished]

  around_action :switch_locale

  SUBMISSION_STATUS_STEP1 = 1
  SUBMISSION_STATUS_STEP2 = 2
  SUBMISSION_STATUS_STEP3 = 3

  def index; end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options(options = {})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end

  def new
    @layer = Layer.find_by_id(layer_from_id)
    if @layer&.public_submission
      @submission = Submission.new
      @submission.name = params[:name]
      @submission.locale = params[:locale]
      @submission.email = params[:email]
      @submission.privacy = params[:privacy]
      @submission.rights = params[:rights]

      @map = @layer.map
      @user = User.new
      @action = 'create'
    else
      redirect_to submissions_path
    end
  end

  def create
    @submission = Submission.find(session[:submission_id]) if session[:submission_id]&.positive?

    @submission = Submission.new(submission_params)
    @submission.status = SUBMISSION_STATUS_STEP1

    @layer = Layer.find(layer_from_id)
    return unless @layer.public_submission

    @map = @layer.map
    @action = 'create'

    respond_to do |format|
      if @submission.save
        session[:submission_id] = @submission.id
        format.html { redirect_to submission_new_place_path(locale: params[:locale], submission_id: @submission.id, layer_id: layer_from_id), notice: t('activerecord.messages.models.submission.created') }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @layer = Layer.find_by_id(layer_from_id)
    if @layer&.public_submission
      if session[:submission_id]&.positive? && session[:submission_id] == submission_from_id
        @submission = Submission.find(session[:submission_id])
      else
        redirect_to submissions_new_path
      end

      @map = @layer.map
      @user = User.new
      @action = 'update'
    else
      redirect_to submissions_path
    end
  end

  def update
    @layer = Layer.find(layer_from_id)
    return unless @layer.public_submission

    if session[:submission_id]&.positive? && session[:submission_id] == submission_from_id
      @submission = Submission.find(session[:submission_id])
    else
      redirect_to submissions_new_path
    end

    @submission.status = SUBMISSION_STATUS_STEP1
    @map = @layer.map
    @action = 'update'
    respond_to do |format|
      if @submission.update(submission_params)
        session[:submission_id] = @submission.id
        if @submission.place
          @submission.place.title = @submission.name
          @submission.place.save!
          format.html { redirect_to submission_edit_place_path(locale: params[:locale], submission_id: @submission.id, layer_id: layer_from_id, place_id: @submission.place.id), notice: t('activerecord.messages.models.submission.created') }
        else
          format.html { redirect_to submission_new_place_path(locale: params[:locale], submission_id: @submission.id, layer_id: layer_from_id), notice: t('activerecord.messages.models.submission.created') }
        end
      else
        format.html { render :edit }
      end
    end
  end

  def new_place
    return unless session[:submission_id]&.positive? && session[:submission_id] == submission_from_id

    @submission = Submission.find(session[:submission_id])

    @layer = Layer.find(layer_from_id)
    @map = @layer.map

    @place = Place.new
    @place.location = params[:location]
    @place.address = params[:address]
    @place.zip = params[:zip]
    @place.city = params[:city]
    @place.country = params[:country]
    @place.lat = params[:lat]
    @place.lon = params[:lon]
    @place.layer_id = layer_from_id
    @action = 'create_place'
  end

  def create_place
    return unless session[:submission_id]&.positive? && session[:submission_id] == submission_from_id

    @submission = Submission.find(session[:submission_id])
    @place = Place.new(place_params)
    @place.layer_id = layer_from_id
    @place.title = @submission.name
    @layer = Layer.find(layer_from_id)
    @map = @layer.map
    @action = 'create_place'

    respond_to do |format|
      if @place.save
        @submission.place = @place
        @submission.status = SUBMISSION_STATUS_STEP2
        @submission.save!
        format.html { redirect_to submission_new_image_path(params[:locale], layer_id: layer_from_id), notice: t('activerecord.messages.models.place.created') }
      else
        format.html { render :new_place }
      end
    end
  end

  def edit_place
    return unless session[:submission_id]&.positive? && session[:submission_id] == submission_from_id

    @submission = Submission.find(session[:submission_id])
    @layer = Layer.find(layer_from_id)
    @map = @layer.map
    @place = @submission.place

    @action = 'update_place'
  end

  def update_place
    return unless session[:submission_id]&.positive? && session[:submission_id] == submission_from_id

    @submission = Submission.find(session[:submission_id])
    @place = @submission.place
    @layer = Layer.find(layer_from_id)
    @map = @layer.map
    @action = 'update_place'

    respond_to do |format|
      if @place.update(place_params)
        @submission.status = SUBMISSION_STATUS_STEP2
        @submission.save!
        format.html { redirect_to submission_new_image_path(params[:locale], layer_id: layer_from_id), notice: t('activerecord.messages.models.place.created') }
      else
        format.html { render :new_place }
      end
    end
  end

  def new_image
    return unless session[:submission_id]&.positive? && session[:submission_id] == submission_from_id

    @image = Image.new

    @layer = Layer.find(layer_from_id)
    @map = @layer.map
    @submission = Submission.find(session[:submission_id])
    @place = @submission.place
  end

  def create_image
    return unless session[:submission_id]&.positive? && session[:submission_id] == submission_from_id

    @submission = Submission.find(session[:submission_id])
    @image = Image.new(image_params)
    @layer = Layer.find(layer_from_id)
    @map = @layer.map
    @place = @submission.place
    @image.place = @place
    @image.place_id = @place.id
    respond_to do |format|
      if params[:image_input] && params[:image_input] == '1'
        if @image.save
          @submission.status = SUBMISSION_STATUS_STEP3
          @submission.save!
          format.html { redirect_to submission_finished_path(params[:locale], submission_id: @submission.id, layer_id: layer_from_id), notice: t('activerecord.messages.models.image.created') }
        else
          format.html { render :new_image }
        end
      else
        @submission.status = SUBMISSION_STATUS_STEP3
        @submission.save!

        format.html { redirect_to submission_finished_path(params[:locale], submission_id: @submission.id, layer_id: layer_from_id), notice: t('activerecord.messages.models.image.created') }
      end
    end
  end

  def finished
    return unless session[:submission_id].positive? && session[:submission_id] == submission_from_id

    @submission = Submission.find(session[:submission_id])
    @place = @submission.place
    @image = Image.sorted_by_place(@place.id)
    @layer = Layer.find(layer_from_id)
    @map = @layer.map
  end

  def layer_from_id
    params[:layer_id].to_i
    # ? direct call via http://127.0.0.1:3000/de/public/submissions/new?layer_id=1 doesn't work anymore
    # 1
  end

  def place_from_id
    return params[:place_id].to_i unless params[:place_id].nil?
    return params[:image_place_id].to_i unless params[:image_place_id].nil?

    0
  end

  def submission_from_id
    params[:submission_id].to_i
  end

  def place_params
    params.require(:place).permit(:title, :teaser, :text, :lat, :lon, :location, :address, :zip, :city, :country, :published, :featured, :imagelink, :layer_id, :icon_id, :audio, tag_list: [], images: [], videos: [])
  end

  def submission_params
    params.require(:submission).permit(:rights, :privacy, :email, :locale, :name)
  end

  def image_params
    params.require(:image).permit(:title, :licence, :source, :creator, :place_id, :alt, :caption, :sorting, :preview, :file)
  end
end
