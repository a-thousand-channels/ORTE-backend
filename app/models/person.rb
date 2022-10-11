# frozen_string_literal: true

class Person < ApplicationRecord
  belongs_to :map
  has_many :annotations, dependent: :restrict_with_error

  validates :name, presence: true
end
