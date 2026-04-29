# frozen_string_literal: true

json.pages do
  json.array! @pages do |page|
    next unless page.published

    json.call(page, :id, :title, :subtitle, :text, :footer, :created_at, :updated_at, :published)
    json.images do
      json.array!(page.images.sort_by { |image| [image.sorting ? 0 : 1, image.sorting] }) do |image|
        json.call(image, :id, :title, :source, :creator, :alt, :sorting, :image_linktag, :image_url, :image_path, :image_filename, :image_on_disk)
      end
    end
  end
end
