# frozen_string_literal: true

class Layer < ApplicationRecord
  belongs_to :map
  has_many :places

  validates :title,  presence: true

  scope :published, -> { where(published: true) }
end
