# frozen_string_literal: true

class Person < ApplicationRecord
  belongs_to :map
  has_many :annotations, dependent: :restrict_with_error

  validates :name, presence: true

  # call me: Person.by_user(current_user).find(params[:id])
  scope :by_map, lambda { |map|
    if user.group.active
      where(group_id: user.group.id) unless user.group.title == 'Admins'
    else
      where(group_id: -1) unless user.group.title == 'Admins'
    end
  }
end
