# frozen_string_literal: true

json.extract! page, :id, :title, :subtitle, :text, :footer, :published, :map_id, :created_at, :updated_at
json.url map_page_url(locale: I18n.locale, map: page.map.id, id: page.id, format: :json)
