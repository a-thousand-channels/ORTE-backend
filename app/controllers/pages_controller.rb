# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_page, only: %i[show edit update destroy]

  def index
    @pages = if admin?
               Page.all
             else
               Page.published
             end
  end

  def new
    @page = Page.new
  end

  def edit; end

  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to page_url(@page), notice: 'Page was successfully created.' }
        format.json { render :index, status: :created, location: @page }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to page_url(@page), notice: 'Page was successfully updated.' }
        format.json { render :index, status: :ok, location: @page }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @page.destroy
      respond_to do |format|
        format.html { redirect_to page_url(@page), notice: 'Page was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to page_url(@page), notice: 'Page could not be destroyed, since its connected to 1 or more annotations.' }
      end
    end
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :is_published, :is_in_menu, :ptype, :teasertext, :fulltext, :footertext)
  end
end
