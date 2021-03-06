# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'validations'

Rails::Initializer.run do |config|
  # config.middleware.use(Rack::Cache,
  #    :verbose => true,
  #    :metastore   => 'file:/var/cache/rack/meta',
  #    :entitystore => 'file:/var/cache/rack/body')
  
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem "newrelic_rpm"
  config.gem "haml"
  config.gem "mislav-will_paginate", :lib => "will_paginate", :source => "http://gems.github.com"
  config.gem "authlogic", :version => "1.4.3"
  config.gem "nokogiri"
  config.gem "bcrypt-ruby", :lib => 'bcrypt'
  config.gem "simplificator-tls-support", :lib => 'tls-support', :source => "http://gems.github.com"
  config.gem "mislav-will_paginate", :lib => 'will_paginate', :source => "http://gems.github.com"
  config.gem "chriseppstein-compass", :lib => 'compass', :source => "http://gems.github.com"
  config.gem "daemons"
  config.gem "json_pure", :lib => 'json'
  config.gem "rest-client", :lib => 'rest_client'

  # For GitHub Messaging Integration
  # config.gem "mechanize"
  # config.gem "mechanical_github"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end
