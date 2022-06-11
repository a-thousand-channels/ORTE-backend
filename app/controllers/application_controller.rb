# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protect_from_forgery with: :exception

  rescue_from ActionController::RoutingError, :with => :error_render_method
  rescue_from ActiveRecord::RecordNotFound, :with => :error_render_method

  def error_render_method
    puts '#####################################'
    puts "Raise Error"
    respond_to do |type|
      # type.xml { render :template => "errors/error_404", :status => 404 }
      # type.all  { render :nothing => true, :status => 404 }
      # type.all  { render :template => 'start/404', :status => 404 }
      type.all { redirect_to notfound_url }
    end
    false
  end

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
end
