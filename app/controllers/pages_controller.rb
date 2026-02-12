# frozen_string_literal: true

class PagesController < ApplicationController
  def show
    @page = Page.published.find_by_slug(params[:id])
  end
end
