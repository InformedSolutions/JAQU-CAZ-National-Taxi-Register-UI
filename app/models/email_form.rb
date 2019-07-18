# frozen_string_literal: true

class EmailForm < BaseForm
  def valid?
    filled? && valid_format?
  end

  private

  def filled?
    @message = 'You must enter your email address'
    parameter.present?
  end

  def valid_format?
    @message = 'You must enter your email in valid format'
    /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/.match(parameter).present?
  end
end
