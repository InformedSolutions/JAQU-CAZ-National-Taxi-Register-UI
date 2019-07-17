# frozen_string_literal: true

class UpdatePasswordForm < BaseForm
  def valid?
    not_to_short? && filled? && correct_password_confirmation?
  end

  private

  def not_to_short?
    @message = 'Your password should include at least 8 characters'
    @error_input = 'password'
    parameter['password'].length > 7
  end

  def correct_password_confirmation?
    @message = "Your password doesn't match password confirmation"
    @error_input = 'password'
    parameter['password'] == parameter['password_confirmation']
  end

  def filled?
    if parameter['confirmation_code'].blank?
      @message = 'You must enter your confirmation code'
      @error_input = 'confirmation_code'
      return false
    elsif parameter['password'].blank?
      @message = 'You must enter your password'
      @error_input = 'password'
      return false
    elsif parameter['password_confirmation'].blank?
      @message = 'You must confirm your password'
      @error_input = 'password_confirmation'
      return false
    else
      return true
    end
  end
end
