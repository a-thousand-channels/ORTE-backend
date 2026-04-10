# frozen_string_literal: true

class Page < ApplicationRecord
  belongs_to :map

  has_many :images, dependent: :destroy
  has_many :videos, dependent: :destroy

  validates :title, presence: true

  extend FriendlyId

  friendly_id :title, use: :slugged

  scope :published, -> { where(published: true) }
end
