class Place < ApplicationRecord

  # self.skip_time_zone_conversion_for_attributes = [:startdate,:startdate_date,:startdate_time]

  belongs_to :layer

  has_many_attached :images

  validates :title,  presence: true

  scope :published, -> { where(published: true) }

  attr_accessor :startdate_date
  attr_accessor :startdate_time
  attr_accessor :enddate_date
  attr_accessor :enddate_time

  before_save do
    if startdate_time
      self.startdate = "#{startdate_date} #{"T"} #{startdate_time}"
    elsif startdate_date
      self.startdate = "#{startdate_date} #{"T"} 00:00:00"
    end
    if enddate_time
      self.enddate = "#{enddate_date} #{"T"} #{enddate_time}"
    elsif enddate_date
      self.enddate = "#{enddate_date} #{"T"} 00:00:00"
    end
  end



  def date
    ApplicationController.helpers.smart_date_display(self.startdate,self.enddate)
  end

  def show_link
    ApplicationController.helpers.show_link(self.title,self.layer.map.id,self.layer.id,id)
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
