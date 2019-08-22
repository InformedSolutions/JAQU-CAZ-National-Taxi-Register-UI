# frozen_string_literal: true

class EmailValidator < BaseService
  attr_reader :email

  def initialize(email:)
    @email = email
  end

  def call
    if invalid_format?
      'Invalid Email Format'
    elsif email_too_long?
      'Email address exceeds the limit of 45 characters'
    end
  end

  private

  def email_too_long?
    email.length > 45
  end

  def invalid_format?
    (email =~ URI::MailTo::EMAIL_REGEXP).nil?
  end
end
