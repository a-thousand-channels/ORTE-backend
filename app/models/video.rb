# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :place

  has_one_attached :file
  delegate_missing_to :file

  has_one_attached :filmstill
  delegate_missing_to :filmstill

  validates :title, presence: true
  validate :check_file_presence
  validate :check_file_format

  scope :sorted, -> { order(sorted: :asc) }
  scope :sorted_by_place, ->(place_id) { where(place_id: place_id).order(sorted: :asc) }
  scope :preview, ->(place_id) { where(place_id: place_id, preview: true) }

  def video_url
    ApplicationController.helpers.video_url(file)
  end

  def video_linktag
    ApplicationController.helpers.video_linktag(file, filmstill)
  end

  private

  def check_file_presence
    errors.add(:file, 'no file present') unless file
  end

  def check_file_format
    errors.add(:file, 'format must be MP4') if file.attached? && !file.content_type.in?(%w[video/mp4 application/mp4])
  end
end
