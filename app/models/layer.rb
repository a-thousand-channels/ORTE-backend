class Layer < ApplicationRecord
  belongs_to :map
  has_many :places


end
