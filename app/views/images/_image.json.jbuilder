json.extract! image, :id, :title, :licence, :source, :creator, :place_id, :alt, :caption, :sorting, :preview, :created_at, :updated_at
json.url image_url(image, format: :json)
