# frozen_string_literal: true

module AudiosHelper
  def audio_url(file)
    return unless file.attached?

    polymorphic_url(file)
  end

  def audio_linktag(file, _title = '')
    return unless file.attached?

    audio_tag(polymorphic_url(file).to_s, controls: true, preload: 'metadata')
  end
end
