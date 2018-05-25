class Place < ApplicationRecord
  belongs_to :layer

  validates :title,  presence: true


  def date
    ApplicationController.helpers.smart_date_display(self.startdate,self.enddate)
  end

  def edit_link
    ApplicationController.helpers.edit_link(self.layer.map.id,self.layer.id,id)
  end

  def full_address
    "#{self.location} #{self.address}"
  end


end
