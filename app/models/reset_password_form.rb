# frozen_string_literal: true

class ResetPasswordForm < BaseForm
  REQUIRED_MSG = 'Username is required'

  def valid?
    filled?
  end

  private

  def filled?
    return true if parameter.present?

    @message = REQUIRED_MSG
    false
  end
end
