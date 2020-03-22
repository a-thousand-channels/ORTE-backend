# frozen_string_literal: true

class Map < ApplicationRecord
  belongs_to :group
  has_many :layers

  validates :title, presence: true

  # call me: Map.by_user(current_user).find(params[:id])
  scope :by_user, lambda { |user|
    where(group_id: user.group.id) unless user.group.title == 'Admins'
  }
  scope :sorted, -> { order(title: :asc) }

  scope :published, -> { where(published: true) }

end
