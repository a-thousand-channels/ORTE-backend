class Map < ApplicationRecord
  belongs_to :group
  has_many :layers
end