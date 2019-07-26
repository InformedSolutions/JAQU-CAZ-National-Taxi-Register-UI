# frozen_string_literal: true

module Cognito
  class RespondToAuthChallenge < BaseService
    attr_reader :user, :password, :confirmation

    def initialize(user:, password:, confirmation:)
      @user = user
      @password = password
      @confirmation = confirmation
    end

    def call
      validate_params
      response = respond_to_auth
      update_user(response.authentication_result.access_token)
      user
    end

    private

    def validation_error_path
      Rails.application.routes.url_helpers.new_password_path
    end

    def system_error_path
      Rails.application.routes.url_helpers.new_user_session_path
    end

    def validate_params
      form = NewPasswordForm.new(
        password: password, confirmation: confirmation, old_password_hash: user.hashed_password
      )
      return if form.valid?

      raise CallException.new(form.message, validation_error_path)
    end

    def update_user(access_token)
      @user = Cognito::GetUser.call(access_token: access_token, user: user)
    end

    def respond_to_auth
      call_cognito
    rescue Aws::CognitoIdentityProvider::Errors::InvalidPasswordException
      raise CallException.new(I18n.t('password.errors.complexity'), validation_error_path)
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      Rails.logger.error e
      raise CallException.new(I18n.t('expired_session'), system_error_path)
    end

    def call_cognito
      COGNITO_CLIENT.respond_to_auth_challenge(
        challenge_name: 'NEW_PASSWORD_REQUIRED',
        client_id: ENV['AWS_COGNITO_CLIENT_ID'],
        session: user.aws_session,
        challenge_responses: {
          'NEW_PASSWORD' => password,
          'USERNAME' => user.username
        }
      )
    end
  end
end
