# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protect_from_forgery with: :exception

  def report_csp
    # do nothing right now...
  end

  def default_checkbox(param)
    %w[on true].include?(param)
  end
end
