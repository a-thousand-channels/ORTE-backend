class Place < ApplicationRecord
  belongs_to :layer

  validates :title,  presence: true

end
