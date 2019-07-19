# frozen_string_literal: true

class NewPasswordForm < BaseForm
  REQUIRED_MSG = 'Password and password confirmation are required'
  EQUALITY_MSG = 'Password and password confirmation must be the same'

  def valid?
    filled? && correct_password_confirmation?
  end

  private

  def password
    parameter[:password]
  end

  def confirmation
    parameter[:password_confirmation]
  end

  def filled?
    return true if password.present? && confirmation.present?

    @message = REQUIRED_MSG
    false
  end

  def correct_password_confirmation?
    return true if password == confirmation

    @message = EQUALITY_MSG
    false
  end
end
