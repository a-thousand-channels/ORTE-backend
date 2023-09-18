# frozen_string_literal: true

class Page < ApplicationRecord
  validates :title, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  scope :sorted, -> { order(title: :asc) }
  scope :published, -> { where(is_published: true) }
  scope :in_menu, -> { where(in_menu: true) }

end
