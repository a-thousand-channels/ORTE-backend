# frozen_string_literal: true

require 'action_mailer'

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
      enable_starttls_auto: true,
      address: Rails.application.credentials.dig(:mail, :address),
      domain: Rails.application.credentials.dig(:mail, :domain),
      port: '465',
      ssl: true,
      authentication: :login,
      user_name: Rails.application.credentials.dig(:mail, :user_name),
      password:  Rails.application.credentials.dig(:mail, :password)
}

class Notifier < ActionMailer::Base
  default from: Rails.application.credentials.dig(:mail, :sender)

  def deploy_notification(notify_emails, stage, git_log)
    now = Time.now
    msg = "Performed a deploy operation on #{now.strftime('%m/%d/%Y')} at #{now.strftime('%I:%M %p')} to #{stage}</br></br>#{git_log}"

    mail(to: notify_emails,
         subject: "Deployed application to #{stage}",
         body: "<pre>#{msg}<\pre>",
         content_type: 'text/html')
  end
end
