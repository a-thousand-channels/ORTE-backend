# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :place

  has_one_attached :file
  delegate_missing_to :file

  validates :title, presence: true
  validate :check_file_presence
  validate :check_file_format

  scope :sorted, -> { order(sorting: :asc) }
  scope :sorted_by_place, ->(place_id) { where('place_id': place_id).order(sorting: :asc) }
  scope :preview, ->(place_id) { where('place_id': place_id, 'preview': true) }

  def image_filename
    file.filename if file&.attached?
  end

  def image_url
    ApplicationController.helpers.image_url(file)
  end

  def image_path
    ApplicationController.helpers.image_path(file)
  end

  def image_linktag
    ApplicationController.helpers.image_linktag(file, title)
  end

  def image_on_disk
    full_path = ActiveStorage::Blob.service.path_for(file.key)
    full_path.gsub(Rails.root.to_s, '')
  end

  private

  def check_file_presence
    errors.add(:file, 'no file present') unless file
  end

  def check_file_format
    errors.add(:file, 'format must be JPG/PNG or GIF') if file.attached? && !file.content_type.in?(%w[image/png image/jpeg image/gif])
  end
end
