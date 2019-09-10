# frozen_string_literal: true

module Cognito
  class ConfirmForgotPassword < CognitoBaseService
    attr_reader :username, :password, :code, :password_confirmation

    def initialize(username:, password:, code:, password_confirmation:)
      @username = username
      @password = password
      @password_confirmation = password_confirmation
      @code = code
    end

    def call
      validate_params
      preform_cognito_call
      true
    end

    private

    def validate_params
      form = ConfirmResetPasswordForm.new(
        password: password,
        confirmation: password_confirmation,
        code: code
      )
      return if form.valid?

      log_invalid_params(form.message)
      raise CallException, form.message
    end

    def preform_cognito_call
      confirm_forgot_password
    rescue AWS_ERROR::CodeMismatchException, AWS_ERROR::ExpiredCodeException => e
      log_error e
      raise CallException, I18n.t('password.errors.code_mismatch')
    rescue AWS_ERROR::InvalidPasswordException, AWS_ERROR::InvalidParameterException => e
      log_error e
      raise CallException, I18n.t('password.errors.complexity')
    rescue AWS_ERROR::ServiceError => e
      log_error e
      raise CallException, 'Something went wrong'
    end

    def confirm_forgot_password
      log_action "Confirming forgot password by a user: #{username}"
      COGNITO_CLIENT.confirm_forgot_password(
        client_id: ENV['AWS_COGNITO_CLIENT_ID'],
        username: username,
        password: password,
        confirmation_code: code
      )
      log_successful_call
    end
  end
end
