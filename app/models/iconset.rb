class Iconset < ApplicationRecord
  has_many :icons
  has_many :maps

  validates :title,  presence: true

end
