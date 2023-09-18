# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_pages_in_menu

  protect_from_forgery with: :exception



  def report_csp
    # do nothing right now...
  end

  def default_checkbox(param)
    if %w[on true].include?(param)
      true
    else
      false
    end
  end

  private

  def set_pages_in_menu
    @pages = Page.published.in_menu
  end
end
