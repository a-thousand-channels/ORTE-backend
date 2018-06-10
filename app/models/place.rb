class Place < ApplicationRecord
  belongs_to :layer

  validates :title,  presence: true

  scope :published, -> { where(published: true) }

  def date
    ApplicationController.helpers.smart_date_display(self.startdate,self.enddate)
  end

  def edit_link
    ApplicationController.helpers.edit_link(self.layer.map.id,self.layer.id,id)
  end

  def full_address
    if self.location.present? && self.address.present?
      if self.location == self.address
        "#{self.location}"
      else
        "#{self.location} #{self.address}"
      end
    elsif self.location.present?
      "#{self.location}"
    else
      "#{self.address}"
    end
  end

  def full_address_with_city
    c = ''
    if self.zip && self.city
      c = ", #{self.zip} #{self.city}"
    end
    "#{self.full_address}#{c}"
  end



end
