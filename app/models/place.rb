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

  scope :sorted_by_startdate, -> { order(startdate: :asc) }
  scope :sorted_by_title, -> { order(title: :asc) }

  scope :published, -> { where(published: true) }

  attr_accessor :startdate_date, :startdate_time, :enddate_date, :enddate_time

  after_initialize :sensitive_location
  attribute :public_lat
  attribute :public_lon

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

  def sensitive_location
    if sensitive
      locs = random_loc(long: read_attribute(:lon), lat: read_attribute(:lat), radius_meters: read_attribute(:sensitive_radius))
      self.public_lon = locs[0].to_s
      self.public_lat = locs[1].to_s
    else
      self.public_lat = read_attribute(:lat)
      self.public_lon = read_attribute(:lon)
    end
  end

  def random_loc(long:, lat:, radius_meters:)
    u = SecureRandom.random_number(1.0)
    v = SecureRandom.random_number(1.0)
    w = radius_meters / 111_300.0 * Math.sqrt(u)
    t = 2 * Math::PI * v
    x = w * Math.cos(t)
    y = w * Math.sin(t)
    [x + long.to_f, y + lat.to_f]
  end

  def layer_id
    layer.id
  end

  def layer_title
    layer.title
  end

  def layer_slug
    layer.title.parameterize
  end

  def layer_type
    layer.ltype
  end

  def color
    layer.color
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
    icon ? ApplicationController.helpers.icon_name(icon.title) : ''
  end

  def icon_link
    icon&.file&.attached? ? ApplicationController.helpers.icon_link(icon.file) : ''
  end

  def icon_class
    icon&.iconset&.class_name ? ApplicationController.helpers.icon_class(icon.iconset.class_name, icon.title) : ''
  end

  def imagelink2
    i = Image.preview(id)
    i.count.positive? ? ApplicationController.helpers.image_link(i.first) : ''
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
    attributes = %w[id title teaser_as_text text_as_text annotations_as_text startdate enddate public_lat public_lon location address zip city country]
    headers = %w[id title teaser text annotations startdate enddate lat lon location address zip city country]
    CSV.generate(headers: false, force_quotes: false, strip: true) do |csv|
      csv << headers
      all.each do |place|
        csv << attributes.map { |attr| place.send(attr) }
      end
    end
  end

  private

  def check_audio_format
    errors.add(:audio, 'format must be MP3.') if audio.attached? && !audio.content_type.in?(%w[audio/mpeg])
  end
end
