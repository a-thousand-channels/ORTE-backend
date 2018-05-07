json.extract! layer, :id, :title, :text, :published, :map_id, :created_at, :updated_at
json.url map_layer_url(layer, format: :json)
