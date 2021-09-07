# frozen_string_literal: true

module IconsHelper
  def icon_url(file)
    return unless file.attached?

    polymorphic_url(file)
  end

  def icon_linktag(file)
    return unless  file.attached?

    "<img src=\"#{polymorphic_url(file)}\">".html_safe
  end
end
