require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Verisolutions
  class Application < Rails::Application

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.

    config.active_record.raise_in_transactional_callbacks = true
    config.assets.enabled = true
    config.assets.initialize_on_precompile = true

    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true

    #config.middleware.use Rack::RedisThrottle::Daily, max: 100000

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end

    # config.time_zone = 'UTC'
    # config.active_record.default_timezone = 'UTC'

    config.generators.javascripts = false

    config.secret_key_base = ENV['SECRET_KEY_BASE']

    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.assets.precompile << Proc.new { |path| path =~ /font-awesome\/fonts/ and File.extname(path).in?(['.otf', '.eot', '.svg', '.ttf', '.woff']) }

    config.to_prepare do
      Devise::Mailer.layout 'mail'
      Devise::Mailer.helper :mail
    end

    config.lograge.enabled = true
    config.lograge.custom_options = lambda do |event|
      exceptions = %w(controller action format id)
      {
        params: event.payload[:params].except(*exceptions)
      }
    end
    config.lograge.formatter = Lograge::Formatters::Json.new
  end
end
