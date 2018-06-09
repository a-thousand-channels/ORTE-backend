class Group < ApplicationRecord
  has_many :users
  has_many :maps

  # call me: Group.by_user(current_user).find(params[:id])
  scope :by_user, lambda { |user|
    where(:id => user.group.id) unless user.group.title == 'Admins'
  }
end
