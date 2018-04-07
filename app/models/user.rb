# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include ModelAuthorization

  validates :role,  presence: true,
                    inclusion: { in: Ability.role_symbols.map(&:to_s) }

  def admin?
    role == 'admin'
  end

  def self.current_ability=(ability)
    Thread.current[:ability] = ability
  end

  def self.current_ability
    Thread.current[:ability]
  end

  def self.perform_authorization?
    !!current_ability
  end
end
