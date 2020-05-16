# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :role
  attr_reader :user

  def initialize(user = nil)
    @user = user
    @role = user ? user.role.to_sym : :disabled

    case role

    when :admin
      can :manage, :all

    when :user then
      can :read,    User,             id: user.id
      can :update,  User,             id: user.id

    end
  end

  def self.role_symbols
    %i[
      admin
      user
    ]
  end
end
