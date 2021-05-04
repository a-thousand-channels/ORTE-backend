# frozen_string_literal: true

class Layer < ApplicationRecord
  belongs_to :map
  has_many :places
  has_one :submission_config

  validates :title, presence: true

  scope :published, -> { where(published: true) }
end
