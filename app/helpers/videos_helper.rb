# frozen_string_literal: true

module VideosHelper
  def video_url(file)
    return unless file.attached?

    polymorphic_url(file)
  end

  def video_linktag(file, filmstill, _title = '')
    return unless file.attached?

    if filmstill && filmstill.attached?
      video_tag(polymorphic_url(file).to_s, controls: true, preload: 'metadata', poster: polymorphic_url(filmstill).to_s, poster_skip_pipeline: true)
    else
      video_tag(polymorphic_url(file).to_s, controls: true, preload: 'metadata')
    end
  end
end
