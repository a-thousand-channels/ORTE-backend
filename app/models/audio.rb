# frozen_string_literal: true

class Audio < ApplicationRecord
  belongs_to :audioable, polymorphic: true

  has_one_attached :file

  validates :title, presence: true
  validates :locale, presence: true
  validate :check_file_presence
  validate :check_file_format

  scope :sorted, -> { order(sorting: :asc) }
  scope :sorted_by_place, ->(place_id) { where(audioable_type: 'Place', audioable_id: place_id).order(sorting: :asc) }

  def audio_filename
    file.filename if file&.attached?
  end

  def audio_format
    file.content_type if file&.attached?
  end

  def audio_url
    ApplicationController.helpers.audio_url(file)
  end

  def audio_linktag
    ApplicationController.helpers.audio_linktag(file)
  end

  def audio_on_disk
    return unless file&.attached?
    return unless ActiveStorage::Blob.service.exist?(file.blob.key)

    full_path = ActiveStorage::Blob.service.path_for(file.key)
    return unless File.exist?(full_path)

    full_path.gsub(Rails.root.to_s, '')
  end

  private

  def check_file_presence
    errors.add(:file, 'no file present') unless file
  end

  def check_file_format
    errors.add(:file, 'format must be MP3 or M4A') if file.attached? && !file.content_type.in?(%w[audio/mpeg audio/x-m4a audio/mp4])
  end
end
