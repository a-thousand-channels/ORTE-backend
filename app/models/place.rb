# frozen_string_literal: true

require 'csv'

class Place < ApplicationRecord
  # self.skip_time_zone_conversion_for_attributes = [:startdate,:startdate_date,:startdate_time]

  belongs_to :layer
  belongs_to :icon, optional: true

  acts_as_taggable_on :tags

  has_one_attached :audio, dependent: :destroy

  has_many :relations_tos, foreign_key: 'relation_to_id',
                           class_name: 'Relation',
                           dependent: :destroy
  has_many :relations_froms, foreign_key: 'relation_from_id',
                             class_name: 'Relation',
                             dependent: :destroy
  accepts_nested_attributes_for :relations_tos, allow_destroy: true
  accepts_nested_attributes_for :relations_froms, allow_destroy: true

  has_many :images, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_many :annotations
  accepts_nested_attributes_for :annotations, reject_if: ->(a) { a[:title].blank? }, allow_destroy: true

  validates :title, presence: true
  validate :check_audio_format

  scope :published, -> { where(published: true) }

  attr_accessor :startdate_date, :startdate_time, :enddate_date, :enddate_time

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

  def title_and_location
    if !location.blank?
      "#{title} (#{location})"
    else
      title
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

  def layer_color
    layer.color
  end

  def icon_name
    ApplicationController.helpers.icon_name(icon.title) if icon
  end

  def icon_link
    ApplicationController.helpers.icon_link(icon.file) if icon&.file&.attached?
  end

  def icon_class
    ApplicationController.helpers.icon_class(icon.iconset.class_name, icon.title) if icon&.iconset&.class_name
  end

  def imagelink2
    i = Image.preview(id)
    ApplicationController.helpers.image_link(i.first) if i.count.positive?
  end

  def audiolink
    ApplicationController.helpers.audio_link(audio) if audio
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

  def annotations_as_text
    t = ''
    return unless annotations&.count&.positive?

    annotations.each do |a|
      t = "#{t}#{a.person.name}:\n" if a.person
      t = "#{t}#{a.title}\n" if a.title
      t = "#{t}#{a.text.html_safe}\n"
      t += "---------------\n"
    end
    t.to_s
  end

  def teaser_as_text
    require 'nokogiri'
    Nokogiri::HTML(teaser).text
  end

  def text_as_text
    require 'nokogiri'
    Nokogiri::HTML(text).text
  end

  def self.to_csv
    attributes = %w[id title teaser_as_text text_as_text annotations_as_text startdate enddate lat lon location address zip city country]
    headers = %w[id title teaser text annotations startdate enddate lat lon location address zip city country]
    CSV.generate(headers: false, force_quotes: false, strip: true) do |csv|
      csv << headers
      all.each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  private

  def check_audio_format
    errors.add(:audio, 'format must be MP3.') if audio.attached? && !audio.content_type.in?(%w[audio/mpeg])
  end
end
