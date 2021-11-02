class Person < ApplicationRecord
  has_many :annotations, dependent: :destroy

  validates :name, presence: true

  scope :published, -> { where(published: true) }
end
