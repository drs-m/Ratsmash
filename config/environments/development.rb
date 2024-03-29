Ratsmash::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Do care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  #mail settings
  # Do care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  if File.exist?(Rails.root + "mail_auth.txt")
    contents = File.read("mail_auth.txt").split("\n")
    mail_user = contents[0]
    mail_password = contents[1]

    config.action_mailer.default :charset => "utf-8"
    config.action_mailer.perform_deliveries = true
    config.enable_mail_delivery = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              "",
      port:                 465,
      user_name:            mail_user,
      password:             mail_password,
      authentication:       :plain,
      enable_starttls_auto: true,
      ssl:                  true
    }
  end
end
