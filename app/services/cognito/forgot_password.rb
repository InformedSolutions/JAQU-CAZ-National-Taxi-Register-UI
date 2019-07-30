# frozen_string_literal: true

module Cognito
  class ForgotPassword < BaseService
    ERROR_PATH = Rails.application.routes.url_helpers.reset_passwords_path
    attr_reader :username

    def initialize(username:)
      @username = username
    end

    def call
      validate_params
      cognito_call
      true
    end

    private

    def validate_params
      form = ResetPasswordForm.new(username)
      return if form.valid?

      raise CallException.new(form.message, ERROR_PATH)
    end

    def cognito_call
      COGNITO_CLIENT.forgot_password(
        client_id: ENV['AWS_COGNITO_CLIENT_ID'],
        username: username
      )
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      Rails.logger.error e
      raise CallException.new("User with email '#{username}' was not found", ERROR_PATH)
    end
  end
end
