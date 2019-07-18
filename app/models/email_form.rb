# frozen_string_literal: true

class EmailForm < BaseForm
  def valid?
    if unfilled? || invalid_format?
      false
    else
      true
    end
  end

  private

  def unfilled?
    if parameter.blank?
      @message = 'You must enter your email address'
    end
  end

  def invalid_format?
    if /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/.match(parameter).blank?
      @message = 'You must enter your email in valid format'
    end
  end
end
