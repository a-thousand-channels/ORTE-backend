# frozen_string_literal: true

module ModelAuthorization
  extend ActiveSupport::Concern

  included do
    before_create :authorize_create!
    before_update :authorize_update!
    before_destroy :authorize_destroy!
    default_scope -> { authorized }
  end

  module ClassMethods
    # If an Ability is present for the User we will apply the accessible_by
    # scope to ensure only records the User is authorized to read are fetched.
    # For every request the Ability is set in ApplicationController.
    def authorized
      if User.perform_authorization?
        accessible_by(User.current_ability, :read)
          .readonly(false)
      else
        all
      end
    end
  end

  protected

  def authorize_create!
    authorize_section! :create
  end

  def authorize_read!
    authorize_section! :read
  end

  def authorize_update!
    authorize_section! :update
  end

  def authorize_destroy!
    authorize_section! :destroy
  end

  def authorize_section!(section)
    User.current_ability.authorize!(section, self) if User.perform_authorization?
  rescue CanCan::AccessDenied => e
    logger.error "authorize_#{section}! -- AccessDenied for Class #{self.class.name}"
    raise "CanCan::AccessDenied for Class #{self.class.name} in authorize_#{section}!"
  end
end
