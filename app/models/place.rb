# frozen_string_literal: true

require 'csv'

class Place < ApplicationRecord
  # self.skip_time_zone_conversion_for_attributes = [:startdate,:startdate_date,:startdate_time]

  belongs_to :layer

  acts_as_taggable_on :tags

  # deprecated, will be removed after transitions
  has_many_attached :images

  has_one_attached :audio

  has_many :images

  validates :title, presence: true
  validate :check_audio_format

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
    end
    if enddate_date.present? && enddate_time.present?
      self.enddate = "#{enddate_date} #{enddate_time}"
    elsif enddate_date.present?
      self.enddate = "#{enddate_date} 00:00:00"
    end
  end




  def date
    ApplicationController.helpers.smart_date_display(startdate, enddate)
  end

  def show_link
    ApplicationController.helpers.show_link(title, layer.map.id, layer.id, id)
  end

  def edit_link
    ApplicationController.helpers.edit_link(layer.map.id, layer.id, id)
  end

  def imagelink2
    i = Image.preview(id)
    if i.count > 0
      ApplicationController.helpers.image_link(i.first)
    else
      imagelink
    end
  end

  def full_address
    if location.present? && address.present?
      if location == address
        location
      else
        "#{location} #{address}"
      end
    elsif location.present?
      location
    else
      address
    end
  end

  def full_address_with_city
    c = ''
    c = ", #{zip} #{city}" if zip && city
    "#{full_address}#{c}"
  end

  def self.to_csv
    attributes = %w[id title teaser text startdate enddate lat lon location address zip city country]

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  private

  def check_audio_format
    if audio.attached? && !audio.content_type.in?(%w(audio/mpeg))
      errors.add(:audio, 'Format must be MP3.')
    end
  end
end
