# frozen_string_literal: true

##
# Module used to send emails via AWS SES
#
module Ses
  ##
  # Sends an email to the user with successful CSV upload confirmation
  #
  # ==== Usage
  #    user = User.new
  #    user.email = 'test@example.com'
  #    time = Time.current.strftime(Rails.configuration.x.time_format)
  #    job_data = { filename: 'name.csv', submission_time: time }
  #    SendSuccessEmail.call(user: user, job_data: job_data)
  #
  class SendSuccessEmail < BaseService

    ##
    # Initializer method for the class. Used by class level method {call}[rdoc-ref:BaseService::call]
    #
    # ==== Attributes
    #
    # * +user+ - an instance of {User class}[rdoc-ref:User] with an email address set
    # * +job_data+ - hash with data about the upload job
    #   * +filename+ - string, name of the submitted file
    #   * +submission_time+ - string, time of the file submission as a string
    def initialize(user:, job_data:)
      @user = user
      job_data = job_data.transform_keys(&:to_sym)
      @filename = job_data[:filename]
      @submission_time = job_data[:submission_time]
    end

    ##
    # Executing method for the class. Used by class level method {call}[rdoc-ref:BaseService::call]
    #
    # Returns true if sending email was successful, false if not. Rescues all the errors.
    #
    def call
      send_email
      true
    rescue StandardError => e
      log_error(e)
      false
    end

    private

    # Calls the mailer class
    def send_email
      log_action("Sending :success_upload email to #{user.email}")
      UploadMailer.success_upload(user, filename, submission_time).deliver
      log_action('Email sent successfully')
    end

    # User instance
    attr_reader :user
    # Name of the submitted file
    attr_reader :filename
    # Time of the file submission
    attr_reader :submission_time
  end
end
