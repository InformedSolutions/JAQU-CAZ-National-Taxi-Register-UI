# frozen_string_literal: true

##
# This class is used to upload csv file to AWS S3.
#
class CsvUploadService < BaseService
  # regular expression for validating filename.
  NAME_FORMAT = /^CAZ-([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))-([a-zA-Z0-9]+)$/
  ##
  # Initializer method.
  #
  # ==== Attributes
  #
  # * +file+ - uploaded file
  # * +user+ - an instance of the User class
  # * +error+ - nil, default error message
  def initialize(file:, user:)
    @file = file
    @user = user
    @error = nil
  end

  # The caller method for the service. It invokes validating and uploading file to AWS S3
  #
  # Returns a boolean
  def call
    validate
    upload_to_s3
  end

  private

  # Validates a csv file.
  #
  # Raises exception if at least one validation not returns true.
  #
  # Returns a boolean.
  def validate
    return unless no_file_selected? || invalid_extname? || invalid_filename? || filesize_too_big?

    raise CsvUploadFailureException, error
  end

  # Checks if file is present.
  # If not, add error message to +error+.
  #
  # Returns a boolean if file is present.
  # Returns a string if not.
  def no_file_selected?
    @error = I18n.t('csv.errors.no_file') if file.nil?
  end

  # Checks if filename extension equals `csv`.
  # If not, add error message to +error+.
  #
  # Returns a boolean if filename extension equals `csv`.
  # Returns a string if not.
  def invalid_extname?
    @error = I18n.t('csv.errors.invalid_ext') unless File.extname(file.original_filename).downcase == '.csv'
  end

  # Checks if filename is compliant with the naming rules.
  # If not, add error message to +error+.
  #
  # Returns a boolean if filename is compliant with the naming rules
  # Returns a string if not.
  def invalid_filename?
    return unless File.basename(file.original_filename, '.*').match(NAME_FORMAT).nil?

    @error = I18n.t('csv.errors.invalid_name')
  end

  # Checks if file size not bigger than `Rails.configuration.x.csv_file_size_limit`
  # Returns a boolean if filename is compliant with the naming rules
  # Returns a string if not.
  def filesize_too_big?
    csv_file_size_limit = Rails.configuration.x.csv_file_size_limit
    @error = "The CSV must be smaller than #{csv_file_size_limit}MB" if file.size > csv_file_size_limit.megabytes
  end

  # Uploading file to AWS S3.
  #
  # Raise exception if upload failed
  #
  # Returns a boolean.
  def upload_to_s3
    log_action('Uploading file to s3')
    return true if aws_call

    raise CsvUploadFailureException, I18n.t('csv.errors.base')
  rescue Aws::S3::Errors::ServiceError => e
    log_error e
    raise CsvUploadFailureException, I18n.t('csv.errors.base')
  end

  # Uploading file to AWS S3.
  #
  # Returns a boolean.
  def aws_call
    s3_object = AMAZON_S3_CLIENT.bucket(bucket_name).object(file.original_filename)
    s3_object.upload_file(file, metadata: metadata)
  end

  # Returns hash with metadata
  def metadata
    { 'uploader-id': user.preferred_username, email: user.username, content_type: 'text/csv' }
  end

  # AWS S3 Bucket Name.
  #
  # Returns a string.
  def bucket_name
    ENV.fetch('S3_AWS_BUCKET', 'S3_AWS_BUCKET')
  end

  # Attributes used internally to save values.
  attr_reader :file, :error, :user
end
