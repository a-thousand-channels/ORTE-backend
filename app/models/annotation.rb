class Annotation < ApplicationRecord
  belongs_to :place
  belongs_to :person

  validates :title, presence: true

  scope :published, -> { where(published: true) }
end
