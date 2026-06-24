# frozen_string_literal: true

class PagesController < ApplicationController
  include ImportContextHelper

  before_action :set_locale
  before_action :set_pageable_context, only: %i[index new create]
  before_action :set_page, only: %i[show edit update destroy images]
  before_action :set_pageable_from_page, only: %i[edit update destroy]
  before_action :redirect_to_friendly_id, only: %i[show]

  protect_from_forgery except: :show

  # GET /pages
  # GET /pages.json
  def index
    @map = @pageable if @pageable.is_a?(Map)
    @pages = @pageable.pages
  end

  def images
    @page = Page.friendly.find(params[:id])
    @map = @page.map if @page.map
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    if @page
      # Check if user has access to the page's pageable
      if @page.pageable_type == 'Map'
        begin
          Map.by_user(current_user).find(@page.pageable_id)
        rescue ActiveRecord::RecordNotFound
          redirect_to root_path, notice: 'Sorry, this map could not be found.'
          return
        end
      end
      
      respond_to do |format|
        format.html { render :show }
        format.json { render :show }
      end
    else
      redirect_to root_path, notice: 'Sorry, this page could not be found.'
    end
  end

  # GET /pages/new
  def new
    @page = Page.new
    respond_to do |format|
      format.html { render :new }
    end
  end

  # GET /pages/1/edit
  def edit
    @translation_missing_for_locale = translation_missing_for_current_locale?(@page)
    respond_to do |format|
      format.html { render :edit }
    end
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params.merge(pageable: @pageable))
  
    respond_to do |format|
      if @page.save
        format.html { redirect_to polymorphic_path([@pageable, @page], locale: @locale), notice: 'Page was created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    pageable = @page.pageable
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to polymorphic_path([pageable, @page], locale: @locale), notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    pageable = @page.pageable
    @page.destroy
    respond_to do |format|
      format.html { redirect_to polymorphic_path(pageable, locale: @locale), notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sort
    @image_ids = params[:images]
    n = 1
    ActiveRecord::Base.transaction do
      @image_ids.each do |dom_id|
        # dom_id is like "image_20"
        id = dom_id.gsub('image_', '')
        image = Image.find(id)
        image.sorting = n
        n += 1
        image.save
      end
    end
    render json: {}
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    @locale = I18n.locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_pageable_context
    if params[:map_id]
      @pageable = Map.by_user(current_user).friendly.find(params[:map_id])
    elsif params[:place_id]
      @pageable = Place.find(params[:place_id])
    end
  end

  def build_params
    params.require(:page).permit(:content, :build)
  end

  def redirect_to_friendly_id
    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    pageable = @page.pageable
    redirect_to polymorphic_path([pageable, @page], locale: @locale), status: :moved_permanently if @page && request.path != polymorphic_path([pageable, @page], locale: @locale) && request.format == 'html'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = find_page_with_locale_fallback(params[:id])
  end

  def set_pageable_from_page
    return unless @page

    @pageable = @page.pageable
    @map = @pageable if @pageable.is_a?(Map)
  end

  # fallback if original language exists, but not the requested translation
  def find_page_with_locale_fallback(identifier)
    Page.friendly.find(identifier)
  rescue ActiveRecord::RecordNotFound
    page = Page.find_by(id: identifier)
    return page if page

    I18n.available_locales.each do |locale|
      page = I18n.with_locale(locale) { Page.friendly.find_by(slug: identifier) }
      return page if page
    end
  end

  def translation_missing_for_current_locale?(page)
    locale_accessor = :"title_#{I18n.locale}"
    return false unless page.respond_to?(locale_accessor)

    page.public_send(locale_accessor).blank?
  end

  def page_params
    params.require(:page).permit(:title, :subtitle, :teaser, :text, :published, :pageable_id, :pageable_type, :locale, images_files: [])
  end
end
