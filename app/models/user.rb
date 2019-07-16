# frozen_string_literal: true

class User
  # required by Devise
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  extend Devise::Models

  define_model_callbacks :validation
  devise :remote_authenticatable, :timeoutable

  attr_accessor :email, :username

  # Latest devise(v4.6.2) tries to initialize this class with values
  # ignore it for now
  def initialize(options = {}); end

  def sub
    SecureRandom.uuid
  end
end
