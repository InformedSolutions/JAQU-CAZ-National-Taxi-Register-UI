# frozen_string_literal: true

class UploadController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_to_new_password_path
  before_action :check_job_data, only: %i[processing]

  def import
    CsvUploadService.call(file: file, user: current_user)
    correlation_id = SecureRandom.uuid
    job_name = RegisterCheckerApi.register_job(file.original_filename, correlation_id)
    session[:job] = {
      name: job_name,
      filename: file.original_filename,
      submission_time: submission_time,
      correlation_id: correlation_id
    }
    redirect_to processing_upload_index_path
  end

  def processing
    result = RegisterCheckerApi.job_status(job_name, job_correlation_id)
    return if result == 'RUNNING'

    if result == 'SUCCESS'
      redirect_to success_upload_index_path
    else
      redirect_to authenticated_root_path, alert: 'Uploaded file is not valid'
    end
  end

  def index
    if session[:job]
      @job_errors = RegisterCheckerApi.job_errors(job_name, job_correlation_id)
      session[:job] = nil
    end
  end

  def data_rules
    # renders static page
  end

  ##
  # Renders page after successful CSV file processing.
  # Sends {SuccessEmail}[rdoc-ref:Ses::SendSuccessEmail] when visited first time after submission.
  #
  # ==== Path
  #    GET /upload/success
  #
  # ==== Attributes
  # * +job+ - hash in session
  #   * +name+ - UUID, job name received from backend API
  #   * +correlation_id+ - UUID, unique identifier used to communicate with backend API
  #   * +filename+ - string, name of the submitted file
  #   * +submission_time+ - string, time of the file submission in a proper format
  #
  def success
    return unless session[:job]

    unless Ses::SendSuccessEmail.call(user: current_user, job_data: job_data)
      @warning = I18n.t('upload.delivery_error')
    end
    session[:job] = nil
  end

  private

  def job_name
    job_data[:name]
  end

  def job_correlation_id
    job_data[:correlation_id]
  end

  def job_data
    session[:job].transform_keys(&:to_sym)
  end

  def file
    params[:file]
  end

  def redirect_to_new_password_path
    if current_user.aws_status == 'FORCE_NEW_PASSWORD'
      redirect_to new_password_path
    end
  end

  def check_job_data
    if session[:job].nil?
      Rails.logger.error 'Job identifier is missing'
      redirect_to root_path
    end
  end

  # returns current time in a proper format
  def submission_time
    Time.current.strftime(Rails.configuration.x.time_format)
  end
end
