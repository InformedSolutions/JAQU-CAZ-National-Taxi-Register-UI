# frozen_string_literal: true

##
# This class wraps calls being made to the AWS to get API Credentials.
# The base URL for the calls is 169.254.170.2 and the uri is configured by
# +AWS_CONTAINER_CREDENTIALS_RELATIVE_URI+ environment variable.
#
# All methods are on the class level, so there is no initializer method.

class AwsCredentialsApi < BaseApi
  AWS_CONTAINER_CREDENTIALS_RELATIVE_URI = ENV.fetch('AWS_CONTAINER_CREDENTIALS_RELATIVE_URI',
                                                     '/credentials').freeze

  base_uri '169.254.170.2'

  class << self
    ##
    # Calls +AWS_CONTAINER_CREDENTIALS_RELATIVE_URI+ endpoint with +GET+ method
    # and returns AWS credenntials
    #
    # ==== Attributes
    #
    # ==== Example
    #
    #    AwsCredentialsApi.fetch_credentials
    #
    # ==== Result
    #
    # Returns a AWS credentials, eg:
    # {
    #   "AccessKeyId": "ACCESS_KEY_ID",
    #   "Expiration": "EXPIRATION_DATE",
    #   "RoleArn": "TASK_ROLE_ARN",
    #   "SecretAccessKey": "SECRET_ACCESS_KEY",
    #   "Token": "SECURITY_TOKEN_STRING"
    # }
    #
    def fetch_credentials
      log_call('Fetching AWS credentials')
      response = request(:get, AWS_CONTAINER_CREDENTIALS_RELATIVE_URI)
      log_response(response)
      response
    end

    def log_response(response)
      Rails.logger.info "AccessKeyId: #{response['AccessKeyId'].last(4)}"
      Rails.logger.info "Expiration: #{response['Expiration']}"
      Rails.logger.info "SecretAccessKey: #{response['SecretAccessKey'].last(4)}"
      Rails.logger.info "Token: #{response['Token'].last(4)}"
    end
  end
end
