# frozen_string_literal: true

class Layer < ApplicationRecord
  belongs_to :map
  has_many :places
  has_one :submission_config

  has_one_attached :image, dependent: :destroy

  validates :title, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  scope :published, -> { where(published: true) }

  def image_link
    ApplicationController.helpers.image_url(image) if image&.attached?
  end
end
