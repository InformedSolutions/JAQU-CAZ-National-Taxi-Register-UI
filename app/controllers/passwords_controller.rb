# frozen_string_literal: true

class PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_aws_status, only: %i[new create]
  before_action :validate_aws_session, only: %i[new create]
  before_action :validate_passwords, only: :create

  def new; end

  def create
    Cognito::RespondToAuthChallenge.call(user: current_user, password: password)
    update_session_data
    redirect_to success_passwords_path
  rescue Aws::CognitoIdentityProvider::Errors::InvalidPasswordException
    redirect_to new_password_path, alert: 'Password must be at least 8 characters long, ' \
                                          'include at least one upper case letter and a number'
  rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
    Rails.logger.error e
    sign_out current_user
    redirect_to new_user_session_path, alert: 'Your session has expired'
  end

  def success; end

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

  def validate_passwords
    form = NewPasswordForm.new(password_params)
    return if form.valid?

    redirect_to new_password_path, alert: form.message
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def password
    password_params[:password]
  end
end
