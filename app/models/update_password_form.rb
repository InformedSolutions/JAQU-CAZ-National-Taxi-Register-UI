# frozen_string_literal: true

class UpdatePasswordForm < BaseForm
  def valid?
    filled? && correct_password_confirmation?
  end

  private

  def correct_password_confirmation?
    @message = "Your password doesn't match password confirmation"
    @error_input = 'password'
    parameter['password'] == parameter['password_confirmation']
  end

  def filled?
    return confirmation_code_error if parameter['confirmation_code'].blank?
    return password_error if parameter['password'].blank?
    return password_confirmation_error if parameter['password_confirmation'].blank?

    true
  end

  def confirmation_code_error
    @message = 'You must enter your confirmation code'
    @error_input = 'confirmation_code'
    false
  end

  def password_error
    @message = 'You must enter your password'
    @error_input = 'password'
    false
  end

  def password_confirmation_error
    @message = 'You must confirm your password'
    @error_input = 'password_confirmation'
    false
  end
end
