# frozen_string_literal: true

##
# Module used to wrap communication with Amazon Cognito
module Cognito
  ##
  # Base class for all the Cognito services. Inherits from BaseService.
  #
  class CognitoBaseService < BaseService
    # Symbolizes base class for all Aws::CognitoIdentityProvider errors.
    AWS_ERROR = Aws::CognitoIdentityProvider::Errors
    # Count of failed logins
    FAILED_LOGINS_ATTR = 'custom:failed-logins'
    # Lockout time, this will hold an ISO-8601 date but a string is the only other data available for Cognito attributes
    LOCKOUT_TIME_ATTR = 'custom:lockout-time'
    # Env variables associated with the lockout mechanism
    LOCKOUT_LOGIN_ATTEMPTS = ENV.fetch('LOCKOUT_LOGIN_ATTEMPTS', 5).to_i
    # Time for which the user is going to be locked out after exceeding maximum number of failed logins.
    LOCKOUT_TIMEOUT = ENV.fetch('LOCKOUT_TIMEOUT', 30).to_i

    # Logs invalid form message on +error+ level
    #
    # ==== Attributes
    # * +msg+ - Invalid form details message. May include information which field is invalid
    #
    def log_invalid_params(msg)
      Rails.logger.error "[#{self.class.name}] Invalid form params - #{msg}"
    end

    # Returns a string, eg. '/passwords/confirm_reset'
    def forgot_password_error_path
      Rails.application.routes.url_helpers.confirm_reset_passwords_path
    end

    # The user pool ID for the user pool where we want to update user attributes
    def user_pool_id
      ENV['AWS_COGNITO_USER_POOL_ID'].split('/').last
    end

    private

    def client
      Cognito::Client.instance
    end
  end
end
