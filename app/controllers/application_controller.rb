# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protect_from_forgery with: :exception

  def bomb
    raise 'BOOOOMBA - raised on purpose!'
  end

  def report_csp
    # do nothing right now...
  end
end
