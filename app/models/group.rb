# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :users
  has_many :maps

  # use case: Group.find(3).places
  has_many :places, through: :maps

  validates :title, presence: true

  # call me: Group.by_user(current_user).find(params[:id])
  scope :by_user, lambda { |user|
    where(id: user.group.id) unless user.group.title == 'Admins'
  }
end
