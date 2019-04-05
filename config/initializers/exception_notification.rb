require 'exception_notification/rails'

if Rails.env.production? || Rails.env.staging?

  Rails.application.config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix:           "[ORTE Backend - #{::Rails.env}] ",
      sender_address:         %{ technik@3plusx.de  },
      exception_recipients:   %w{ technik@3plusx.de   }
  }

end
