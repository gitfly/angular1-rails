require 'middleware/turbo_dev'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # DEPRECATION WARNING: Currently, Active Record suppresses errors raised within `after_rollback`/`after_commit` callbacks and only print them to the logs. In the next version, these errors will no longer be suppressed. Instead, the errors will propagate normally just like in other Active Record callbacks.
  # You can opt into the new behavior and remove this warning by setting:
  config.active_record.raise_in_transactional_callbacks = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  # config.action_mailer.delivery_method = :letter_opener

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  console do
    ActiveRecord::Base.connection
  end
  #
   config.middleware.insert 0, Middleware::TurboDev

   ActionMailer::Base.delivery_method = :sendmail


  #  ActionMailer::Base.smtp_settings = {
  #  :address => "smtp.exmail.qq.com ",
  #  :port => 25,
  #  :domain => "baozheng.cc",
  #  :authentication => :plain,
  #  :user_name => "mailer@baozheng.cc",
  #  :password => "BaozhengMailer123"
  # }
  ActionMailer::Base.smtp_settings = {
   :address => "smtp.163.com",
   :port => 25,
   :domain => "163.com",
   :authentication => :plain,
   :user_name => "javaBean_ym@163.com",
   :password => "OO00OO00aixue"
  }
end
