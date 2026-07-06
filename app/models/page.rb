# frozen_string_literal: true

class Page < ApplicationRecord
  include HasImages

  belongs_to :pageable, polymorphic: true

  has_many :images, as: :imageable, dependent: :destroy
  has_many :videos, as: :videoable, dependent: :destroy

  validates :title, presence: true

  extend Mobility

  translates :slug,     type: :string
  translates :title,    type: :string
  translates :subtitle, type: :string
  translates :teaser,   type: :text
  translates :text,     type: :text
  translates :footer,   type: :text

  extend FriendlyId

  friendly_id :title, use: %i[mobility slugged]

  scope :published, -> { where(published: true) }

  # Convenience methods for backward compatibility with views
  def map
    pageable if pageable_type == 'Map'
  end

  def place
    pageable if pageable_type == 'Place'
  end

  def map_id
    pageable_id if pageable_type == 'Map'
  end

  def place_id
    pageable_id if pageable_type == 'Place'
  end
end
