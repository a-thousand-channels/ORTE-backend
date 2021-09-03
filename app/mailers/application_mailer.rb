# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'technik@3plusx.de'
  layout 'mailer'


  def notify_user_created(user)
    @user = user
    mail(to: user.email,
         subject: "Your profile for ORTE has been created")
  end


  def notify_admin_user_created(user)
    @user = user
    return unless admin_adresses.any?

    mail(to: admin_adresses,
         subject: "#{get_label('admin')} profile created")
  end

  private

  def admin_adresses
    User.where(role: :admin).joins(:group).where("groups.title = 'Admins'").collect(&:email)
  end

  def get_label(target)
    if Rails.env == 'production'
      production_label(target)
    else
      label_for_other_envs(target)
    end
  end

  def production_label(target)
    if target == 'admin'
      "[#{Settings.app_shortname} Admin]"
    else
      "[#{Settings.app_shortname}]"
    end
  end

  def label_for_other_envs(target)
    if target == 'admin'
      "[#{Settings.app_shortname} Admin -- #{Rails.env}]"
    else
      "[#{Settings.app_shortname} -- #{Rails.env}]"
    end
  end
end
