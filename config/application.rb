# frozen_string_literal: true

require_relative 'boot'

# This is not loaded in rails/all but inside active_record so add it if
# you want your models work as expected
require 'rails/all'
# require 'active_record/railtie'
# require 'action_controller/railtie'
# require 'action_view/railtie'
# require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CsvUploader
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')

    config.x.session_timeout_in_min = (ENV['SESSION_TIMEOUT'].presence || 15).to_i
  end
end
