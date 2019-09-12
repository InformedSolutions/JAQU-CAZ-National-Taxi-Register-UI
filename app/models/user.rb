# frozen_string_literal: true

##
# This class is used to authorize a user account.
class User
  # required by Devise
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  extend Devise::Models

  define_model_callbacks :validation
  devise :remote_authenticatable, :timeoutable

  # Attribute that is being used to authorize a user and use it in csv uploading.
  attr_accessor :email, :username, :aws_status, :aws_session, :sub,
                :confirmation_code, :hashed_password

  # Latest devise(v4.7.1) tries to initialize this class with values, ignore it for now.
  def initialize(options = {}); end

  # Needed for rendering user forms.
  def to_key
    nil
  end

  # Needed for displaying user in console.
  def serializable_hash(_options = nil)
    {
      email: email,
      username: username,
      aws_status: aws_status,
      aws_session: aws_session,
      sub: sub,
      hashed_password: hashed_password
    }
  end
end
