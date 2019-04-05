# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!



ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {

      enable_starttls_auto: true,
      address: "sslout.de",
      port: '465',
      ssl: true,
      domain: "3plusx.de",
      authentication: :login,
      user_name: "pm@3plusx.de",
      password: "Test4o"
}



