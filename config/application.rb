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

    feedback_url_default = 'https://www.surveymonkey.co.uk/r/2T8BX2D'
    config.x.feedback_url = (ENV['FEEDBACK_URL'].presence || feedback_url_default)

    config.time_zone = 'London'
    config.x.time_format = '%d %B %Y %H:%M:%S %Z'

    # https://mattbrictson.com/dynamic-rails-error-pages
    config.exceptions_app = routes

    # https://github.com/aws/aws-sdk-rails
    config.action_mailer.delivery_method = :aws_sdk
    # https://stackoverflow.com/questions/49086693/how-do-i-remove-mail-html-content-from-rails-logs
    config.action_mailer.logger = nil
  end
end
