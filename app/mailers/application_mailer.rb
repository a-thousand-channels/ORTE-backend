# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'technik@3plusx.de'
  layout 'mailer'

  def notify_user_created(user)
    @user = user
    mail(to: user.email,
         subject: 'Your profile for ORTE has been created')
  end

  def notify_admin_user_created(user, admin_adresses)
    @user = user
    return unless admin_adresses.any?

    mail(to: admin_adresses,
         subject: "#{get_label('admin')} profile created")
  end

  private

  def get_label(target)
    if Rails.env == 'production'
      production_label(target)
    else
      label_for_other_envs(target)
    end
  end

  def production_label(target)
    if target == 'admin'
      "[#{Rails.application.config_for(:settings).app_shortname} Admin]"
    else
      "[#{Rails.application.config_for(:settings).app_shortname}]"
    end
  end

  def label_for_other_envs(target)
    if target == 'admin'
      "[#{Rails.application.config_for(:settings).app_shortname} Admin -- #{Rails.env}]"
    else
      "[#{Rails.application.config_for(:settings).app_shortname} -- #{Rails.env}]"
    end
  end
end
