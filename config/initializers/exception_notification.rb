require 'exception_notification/rails'

if Rails.env.production? || Rails.env.staging?

  Rails.application.config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix:           "[ORTE Backend - #{::Rails.env}] ",
      sender_address:         %{ email@email.com },
      exception_recipients:   %w{ email@email.com  }
  }

end
