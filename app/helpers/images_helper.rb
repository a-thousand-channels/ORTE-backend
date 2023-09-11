# frozen_string_literal: true

module ImagesHelper
  def itype_for_select
    [['Image (default)', 'image'], %w[Graphics graphics]]
  end

  def image_url(file)
    return unless file.attached?

    begin
      filename = ActiveStorage::Blob.service.path_for(file.key)
      return unless File.exist?(filename)

      polymorphic_url(file.variant(resize: '800x800').processed)
    rescue Errno::ENOENT => e
      ''
    rescue ActiveStorage::FileNotFoundError => e
      ''
    rescue ActiveStorage::IntegrityError => e
      ''
    end
  end

  def image_path(file)
    return unless file.attached?

    begin
      filename = ActiveStorage::Blob.service.path_for(file.key)
      return unless File.exist?(filename)

      polymorphic_path(file.variant(resize: '800x800').processed)
    rescue Errno::ENOENT => e
      ''
    rescue ActiveStorage::FileNotFoundError => e
      ''
    rescue ActiveStorage::IntegrityError => e
      ''
    end
  end

  def image_linktag(file, title = '')
    return unless file.attached?

    begin
      filename = ActiveStorage::Blob.service.path_for(file.key)
      return unless File.exist?(filename)

      "<img src=\"#{polymorphic_url(file.variant(resize: '800x800').processed)}\" title=\"#{title.present? ? title : ''}\">".html_safe
    rescue Errno::ENOENT => e
      ''
    rescue ActiveStorage::FileNotFoundError => e
      ''
    rescue ActiveStorage::IntegrityError => e
      ''
    end
  end
end
