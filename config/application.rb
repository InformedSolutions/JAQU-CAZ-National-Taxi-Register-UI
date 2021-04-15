# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CsvUploader
  # The class is responsible for building the middleware stack
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    # loads all files in folder
    config.autoload_paths << "#{config.root}/lib"
    # timeout the user session without activity.
    config.x.session_timeout_in_min = ENV.fetch('SESSION_TIMEOUT', 15).to_i
    # link to feedback page.
    config.x.feedback_url = ENV.fetch('FEEDBACK_URL', 'https://defragroup.eu.qualtrics.com/jfe/form/SV_2iugBKyyYVyl0LX')
    # name of service
    config.x.service_name = 'Taxi and PHV Data Portal'
    # Support Email Address
    config.x.support_service_email = ENV.fetch('SUPPORT_SERVICE_EMAIL',
                                               'TaxiPHVDatabase.Support@informed.com')
    # email address for sending emails, eg 'from@example.com'
    default_email = 'TaxiandPHVCentralised.Database@defra.gov.uk'
    config.x.service_email = ENV.fetch('SES_FROM_EMAIL', default_email)

    config.time_zone = 'London'
    config.x.time_format = '%d %B %Y %H:%M:%S %Z'

    # https://mattbrictson.com/dynamic-rails-error-pages
    config.exceptions_app = routes

    # https://github.com/aws/aws-sdk-rails
    config.action_mailer.delivery_method = :aws_sdk

    # https://stackoverflow.com/questions/49086693/how-do-i-remove-mail-html-content-from-rails-logs
    config.action_mailer.logger = nil

    # Configurable CSV upload size limit
    config.x.csv_file_size_limit = ENV.fetch('CSV_FILE_SIZE_LIMIT_MB', 50).to_i
  end
end
