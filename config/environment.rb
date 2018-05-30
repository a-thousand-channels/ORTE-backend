# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!



ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {

      enable_starttls_auto: true,
      address: "domain.org",
      port: '465',
      ssl: true,
      domain: "domain.org",
      authentication: :login,
      user_name: "sender@domain.org",
      password: "abcdefgh"

}