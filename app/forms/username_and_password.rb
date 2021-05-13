# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/devise/sessions/new.html.haml+.
class UsernameAndPassword
  attr_accessor :errors

  ##
  # Initializer method.
  #
  # ==== Attributes
  #
  # * +username+ - string, user email address
  # * +password+ - string, eg. 'password'
  def initialize(username, password)
    @username = username
    @password = password
  end

  ##
  # Validates +username+ and +password+.
  #
  # Returns a boolean.
  def valid?
    both_fields_filled? && fields_filled? && email_format_valid?
  end

  private

  attr_reader :username, :password

  ##
  # Checks if both +username+ and +password+ are filled.
  #
  # Returns a boolean.
  def both_fields_filled?
    return true if username.present? || password.present?

    @errors = { email: I18n.t('email.errors.required'), password: I18n.t('password.errors.required') }
    false
  end

  ##
  # Checks if +username+ or +password+ are filled.
  #
  # Returns a boolean.
  def fields_filled?
    return true if username.present? && password.present?

    @errors = { email: I18n.t('devise.failure.invalid'), password: I18n.t('devise.failure.invalid') }
    false
  end

  ##
  # Checks if +username+ is in correct format.
  #
  # Returns a boolean.
  def email_format_valid?
    error_message = EmailValidator.call(email: username)
    return true if error_message.nil?

    @errors = { email: error_message, password: I18n.t('password.errors.required') } if error_message
    false
  end
end
