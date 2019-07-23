# frozen_string_literal: true

class PasswordsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :validate_aws_status, only: %i[new create]
  before_action :validate_aws_session, only: %i[new create]
  before_action :validate_new_password_form, only: :create

  def new
    # renders view for initial password change
  end

  def create # rubocop:disable Metrics/AbcSize
    # TODO: refactor this by moving redirects and form inside service
    Cognito::RespondToAuthChallenge.call(user: current_user, password: password)
    update_session_data
    redirect_to success_passwords_path
  rescue Aws::CognitoIdentityProvider::Errors::InvalidPasswordException
    redirect_to new_password_path, alert: I18n.t('password.errors.complexity')
  rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
    Rails.logger.error e
    sign_out current_user
    redirect_to new_user_session_path, alert: 'Your session has expired'
  end

  def success
    # change actions success page
  end

  def reset
    # renders view for resetting password
  end

  def send_confirmation_code
    Cognito::ForgotPassword.call(username: username)
    redirect_to confirm_reset_passwords_path(username: username)
  rescue Cognito::CallException => e
    redirect_to e.path, alert: e.message
  end

  def confirm_reset
    @username = params[:username]
  end

  def change
    Cognito::ConfirmForgotPassword.call(
      username: username, password: password, code: code,
      password_confirmation: password_confirmation
    )
    redirect_to success_passwords_path
  rescue Cognito::CallException => e
    redirect_to e.path, alert: e.message
  end

  private

  def update_session_data
    session['warden.user.user.key'] = [current_user.serializable_hash.transform_keys(&:to_s), nil]
  end

  def validate_aws_status
    return if current_user.aws_status == 'FORCE_NEW_PASSWORD'

    redirect_to root_path
  end

  def validate_aws_session
    return if current_user.aws_session

    sign_out current_user
    redirect_to new_user_session_path, alert: 'Your session has expired'
  end

  def validate_new_password_form
    form = NewPasswordForm.new(password_params)
    return if form.valid?

    redirect_to new_password_path, alert: form.message
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :username, :confirmation_code)
  end

  def password
    password_params[:password]
  end

  def password_confirmation
    password_params[:password_confirmation]
  end

  def username
    password_params[:username]
  end

  def code
    password_params[:confirmation_code]
  end
end
