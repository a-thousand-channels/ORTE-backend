# frozen_string_literal: true

class Layer < ApplicationRecord
  belongs_to :map
  has_many :places
  has_one :submission_config

  has_one_attached :image, dependent: :destroy
  has_one_attached :backgroundimage, dependent: :destroy
  has_one_attached :favicon, dependent: :destroy

  validates :title, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  scope :published, -> { where(published: true) }

  def image_link
    ApplicationController.helpers.image_url(image) if image&.attached?
  end

  def image_filename
    image.filename  if image&.attached?
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
end
