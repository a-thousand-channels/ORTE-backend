module ImagesHelper
  def image_url(file)
    if file.attached?
      filename = ActiveStorage::Blob.service.path_for(file.key)
      if  File.exist?(filename)
        polymorphic_url(file.variant(resize: "800x800").processed)
      end
    end
  end
  def image_linktag(file,title='')
    if file.attached?
      filename = ActiveStorage::Blob.service.path_for(file.key)
      if File.exist?(filename)
        "<img src=\"#{polymorphic_url(file.variant(resize: "800x800").processed)}\" title=\"#{(title.present? ? title : '')}\">".html_safe
      end
    end
  end
end
