class Layer < ApplicationRecord
  belongs_to :map
  has_many :places

  scope :published, -> { where(published: true) }
end
