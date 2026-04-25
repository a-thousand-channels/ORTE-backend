# frozen_string_literal: true

class PagesController < ApplicationController
  include ImportContextHelper

  # before_action :redirect_to_localized_url
  before_action :set_locale
  before_action :set_page, only: %i[show edit update destroy]
  before_action :redirect_to_friendly_id, only: %i[show]

  protect_from_forgery except: :show

  # GET /pages
  # GET /pages.json
  def index
    @map = Map.sorted.by_user(current_user).friendly.find(params[:map_id])
    @pages = @map.pages
  end

  def images
    @map = Map.sorted.by_user(current_user).friendly.find(params[:map_id])
    @page = Page.friendly.find(params[:id])
  end

  def fetch_pages
    @map = Map.find(params[:map_id])
    @pages = @map.pages

    respond_to do |format|
      format.json { render json: @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @maps = Map.sorted.by_user(current_user)
    redirect_to maps_path, notice: 'Sorry, this map could not be found.' and return unless @map

    @map_pages = @map.pages

    if @page
      respond_to do |format|
        format.html { render :show }
        format.json { render :show }
      end
    else
      redirect_to maps_path, notice: 'Sorry, this page could not be found.'
    end
  end

  # GET /pages/new
  def new
    @page = Page.new
    @map = Map.by_user(current_user).friendly.find(params[:map_id])

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
    @page = Page.new(page_params)
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    respond_to do |format|
      if @page.save
        format.html { redirect_to map_page_path(@map, @page), notice: 'Page was created.' }
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
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to map_page_path(@map, @page), notice: 'Page was successfully updated.' }
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
    @page.destroy
    respond_to do |format|
      format.html { redirect_to map_path(@map), notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    @locale = I18n.locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def redirect_to_localized_url
    puts "Current locale: #{I18n.locale}, Request path: #{request.path}"
    puts "Locale in params: #{params[:locale]}"
    return if params[:locale].present?

    default_locale = I18n.default_locale
    path = request.path_info
    new_path = "/#{default_locale}#{path}"
    redirect_to new_path, status: 301
  end

  def build_params
    params.require(:page).permit(:content, :build)
  end

  def redirect_to_friendly_id
    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    redirect_to map_page_path(@map, @page), status: :moved_permanently if @map && @page && request.path != map_page_path(@map, @page) && request.format == 'html'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    # puts "Finding map with slug: #{params[:map_id]} or id: #{params[:map_id]}"
    @map = Map.by_user(current_user).find_by_slug(params[:map_id]) || Map.by_user(current_user).find_by_id(params[:map_id])
    @page = find_page_with_locale_fallback(params[:id])
    # puts "Found map: #{@map&.id}, Found page: #{@page&.id}"
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
    params.require(:page).permit(:title, :subtitle, :teaser, :text, :published, :map_id, :locale, images_files: [])
  end
end
