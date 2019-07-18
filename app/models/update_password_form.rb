# frozen_string_literal: true

class UpdatePasswordForm < BaseForm
  def valid?
    if unfilled? || to_short? || invalid_confirmation?
      false
    else
      true
    end
  end

  private

  def to_short?
    if parameter['password'].length < 7
      @message = 'Your password should include at least 8 characters'
      @error_input = 'password'
    end
  end

  def invalid_confirmation?
    if parameter['password'] != parameter['password_confirmation']
      @message = "Your password doesn't match password confirmation"
      @error_input = 'password'
    end
  end

  def unfilled?
    return confirmation_code_error if parameter['confirmation_code'].blank?
    return password_error if parameter['password'].blank?

    password_confirmation_error if parameter['password_confirmation'].blank?
  end

  def confirmation_code_error
    @message = 'You must enter your confirmation code'
    @error_input = 'confirmation_code'
  end

  def password_error
    @message = 'You must enter your password'
    @error_input = 'password'
  end

  def password_confirmation_error
    @message = 'You must confirm your password'
    @error_input = 'password_confirmation'
  end
end
