# frozen_string_literal: true

require 'action_mailer'

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp.domain.com',
  domain:  'domain.com',
  port:    25
}

class Notifier < ActionMailer::Base
  default from: 'email@email.com'

  def deploy_notification(notify_emails, stage, git_log)
    now = Time.now
    msg = "Performed a deploy operation on #{now.strftime('%m/%d/%Y')} at #{now.strftime('%I:%M %p')} to #{stage}</br></br>#{git_log}"

    mail(to: notify_emails,
         subject: "Deployed application to #{stage}",
         body: "<pre>#{msg}<\pre>",
         content_type: 'text/html')
  end
end
