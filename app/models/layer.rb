# frozen_string_literal: true

class Layer < ApplicationRecord
  belongs_to :map
  has_many :places
  has_one :submission_config

  validates :title, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  scope :published, -> { where(published: true) }
end
