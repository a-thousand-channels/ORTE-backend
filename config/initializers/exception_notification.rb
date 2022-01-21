require 'exception_notification/rails'

if Rails.env.production? || Rails.env.staging?

  Rails.application.config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix:           "[ORTE Backend - #{::Rails.env}] ",
      sender_address:         %{ dev@a-thousand-channels.xyz  },
      exception_recipients:   %w{ dev@a-thousand-channels.xyz }
  }

end
