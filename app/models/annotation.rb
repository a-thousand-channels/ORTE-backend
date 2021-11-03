class Annotation < ApplicationRecord
  belongs_to :place
  belongs_to :person, optional: true

  validates :title, uniqueness: true
  validates :text, presence: true

  scope :published, -> { where(published: true) }
end
