# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :place

  has_one_attached :file
  delegate_missing_to :file

  before_save :extract_exif_data

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

  def get_exif_data
    return unless file.attached?

    full_path = ActiveStorage::Blob.service.path_for(file.key)
    exif_data = MiniMagick::Image.open(full_path.to_s)
    exif_data.exif
  end

  private

  def extract_exif_data
    return unless file.attached?
    return unless place.layer.exif_remove

    filename = file.filename.to_s
    attachment_path = "#{Dir.tmpdir}/#{file.filename}"
    File.open(attachment_path, 'wb') do |tmp_file|
      tmp_file.write(file.download)
      tmp_file.close
    end
    exif_data = MiniMagick::Image.open(attachment_path)
    exif_data.auto_orient # Before stripping
    exif_data.strip # Strip Exif
    exif_data.write attachment_path
    file.attach(io: File.open(attachment_path), filename: filename)
  end

  def check_file_presence
    errors.add(:file, 'no file present') unless file
  end

  def check_file_format
    errors.add(:file, 'format must be JPG/PNG or GIF') if file.attached? && !file.content_type.in?(%w[image/png image/jpeg image/gif])
  end
end
