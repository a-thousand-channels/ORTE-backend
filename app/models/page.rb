# frozen_string_literal: true

class Page < ApplicationRecord
  validates :title, presence: true

  scope :sorted, -> { order(title: :asc) }
  scope :published, -> { where(is_published: true) }
  scope :in_menu, -> { where(is_in_menu: true) }
end
