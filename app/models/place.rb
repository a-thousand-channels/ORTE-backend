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
    if startdate_date.present? && startdate_time.present?
      self.startdate = "#{startdate_date} #{startdate_time}"
    elsif startdate_date.present?
      self.startdate = "#{startdate_date} 00:00:00"
    else
      # FIXME: if form field startdate_date is emptied by user
      # the startdate field should be set to null
      # but: this make json validation fail
      # and: it makes model based verification impossible
      # (see spec/models/place_spec.rb line 16 as an example)
      # self.startdate = ""
    end
    if enddate_date.present? && enddate_time.present?
      self.enddate = "#{enddate_date} #{enddate_time}"
    elsif enddate_date.present?
      self.enddate = "#{enddate_date} 00:00:00"
    else
      # self.enddate = ""
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
        self.location
      else
        "#{self.location} #{self.address}"
      end
    elsif self.location.present?
      self.location
    else
      self.address
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
