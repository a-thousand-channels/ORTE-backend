class Annotation < ApplicationRecord
  belongs_to :place

  validates :title, presence: true

  scope :published, -> { where(published: true) }
end
