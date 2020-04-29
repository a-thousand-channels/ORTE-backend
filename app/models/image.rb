class Image < ApplicationRecord
  belongs_to :place

  has_one_attached :file
  delegate_missing_to :file

  scope :sorted, -> { order(sorted: :asc) }  
  scope :sorted_by_place, -> ( place_id ) { where('place_id': place_id).order(sorted: :asc) } 
  scope :preview, -> ( place_id ) { where('place_id': place_id, 'preview': true) } 
   
end
