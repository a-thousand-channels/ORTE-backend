# frozen_string_literal: true

class Public::PagesController < ActionController::Base
  before_action :cors_set_access_control_headers
  around_action :switch_locale

  protect_from_forgery with: :exception

  # For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  # GET /pages/1.json
  def index
    @map = Map.published.find_by_slug(params[:map_id]) || Map.published.find_by_id(params[:map_id])
    return render json: { error: 'Map not accessible' }, status: :forbidden unless @map

    @pages = @map.pages.published.order(:created_at)

    respond_to do |format|
      if @pages.present?
        format.json { render :index, locals: { page: @pages } }
        format.zip do
          zip_file = "orte-page-#{@pages.first.title.parameterize}-#{I18n.l Date.today}.zip"
          @pages.first.to_zip(zip_file)
          send_file "#{Rails.root}/public/#{zip_file}"
        end
      else
        format.json { render json: { error: 'Page not accessible (You\'ll have to publish the page first)' }, status: :forbidden }
      end
    end
  end

  private

  def switch_locale(&)
    I18n.with_locale(extract_locale || I18n.default_locale, &)
  end

  def extract_locale
    parsed_locale = params[:locale].to_s
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
end
