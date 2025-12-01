require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Siade
  class Application < Rails::Application
    config.load_defaults 8.0

    # Time.parse / ma_date.to_time
    #   use the system timezone
    # Time.zone.parse / ma_date.in_time_zone
    #   use Rails.application.config.time_zone if no time_zone defined : UTC
    config.time_zone = 'Europe/Paris'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/validators #{config.root}/app/policies #{config.root}/app/tools)

    # config.assets.enabled = true
    # config.assets.compile = true
    # config.assets.digest = true
    # config.assets.initialize_on_precompile = false

    config.api_only = true

    config.throttle = config_for(:throttle)
    config.jwt_whitelist = config_for(:jwt_whitelist)
    config.requests_debugging = config_for(:requests_debugging)

    config.cache_store = :redis_cache_store, config_for(:cache_redis).merge(
      namespace: "siade_cache_#{Rails.env}_#{Time.now.to_i}",
      expires_in: (7 * 24 * 60 * 60),
    )

    config.active_record.schema_format = :sql
  end
end
