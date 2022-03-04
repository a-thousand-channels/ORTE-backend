# frozen_string_literal: true

include ActionView::Helpers::NumberHelper
class Layer < ApplicationRecord
  belongs_to :map
  has_many :places, dependent: :destroy
  has_one :submission_config

  has_one_attached :image, dependent: :destroy
  has_one_attached :backgroundimage, dependent: :destroy
  has_one_attached :favicon, dependent: :destroy

  validates :title, presence: true

  before_save :extract_exif_data

  extend FriendlyId
  friendly_id :title, use: :slugged

  scope :published, -> { where(published: true) }

  def image_link
    ApplicationController.helpers.image_url(image) if image&.attached?
  end

  def image_filename
    image.filename if image&.attached?
  end

  def backgroundimage_link
    ApplicationController.helpers.image_url(backgroundimage) if backgroundimage&.attached?
  end

  def backgroundimage_filename
    backgroundimage.filename if backgroundimage&.attached?
  end

  def favicon_link
    ApplicationController.helpers.image_url(favicon) if favicon&.attached?
  end

  def favicon_filename
    favicon.filename if favicon&.attached?
  end

  def to_zip(output_filename)
    rand_id = SecureRandom.uuid
    images_tmp_folder = "tmp/layer_#{rand_id}_images"
    tmp_file = "#{images_tmp_folder}/layer.json"
    output_file = "public/#{output_filename}"

    layer, images_on_disc = Build::Maptogo.new(nil, nil, self).generate_layer_json(self, '')

    FileUtils.mkdir_p images_tmp_folder
    File.open(tmp_file, 'w') { |file| file.write(JSON.generate(layer)) }
    images_on_disc.each do |file_hash|
      dest_folder = "#{images_tmp_folder}/#{file_hash['filename']}"
      FileUtils.cp(file_hash['disk'], dest_folder)
    end

    if Dir.exist?(images_tmp_folder)
      zf = ZipFileGenerator.new(images_tmp_folder, output_file)
      zf.write
    end
    FileUtils.rm_rf(images_tmp_folder)
    output_file
  end

  def get_exif_data
    return unless image.attached?

    full_path = ActiveStorage::Blob.service.path_for(image.key)
    exif_data = MiniMagick::Image.open(full_path.to_s)
    exif_data.exif
  end

  private

  def extract_exif_data
    return unless image.attached?
    return unless exif_remove

    filename = image.filename.to_s
    attachment_path = "#{Dir.tmpdir}/#{image.filename}"
    File.open(attachment_path, 'wb') do |tmp_file|
      tmp_file.write(image.download)
      tmp_file.close
    end
    exif_data = MiniMagick::Image.open(attachment_path)
    exif_data.auto_orient # Before stripping
    exif_data.strip # Strip Exif
    exif_data.write attachment_path
    image.attach(io: File.open(attachment_path), filename: filename)
  end
end
