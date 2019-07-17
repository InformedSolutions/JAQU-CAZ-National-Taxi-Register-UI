# frozen_string_literal: true

class EmailForm < BaseForm
  def valid?
    filled?
  end

  private

  def filled?
    @message = 'You must enter your email address'
    parameter.present?
  end
end
