# frozen_string_literal: true

class Person < ApplicationRecord
  has_many :annotations, dependent: :restrict_with_error

  validates :name, presence: true

  scope :published, -> { where(published: true) }
end
