# frozen_string_literal: true

class UploadController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_to_new_password_path
  before_action :check_job_uuid, only: %i[processing]

  def import
    CsvUploadService.call(file: file, user: current_user)
    session[:job_uuid] = Connection::RegisterCheckerApi.register_job(file.original_filename)

    redirect_to processing_upload_index_path
  end

  def processing
    result = ProcessingJobService.call(job_uuid: session[:job_uuid])

    if result.in_progress?
      # render processing page
    else
      session[:job_uuid] = nil
      handle_job(result)
    end
  end

  def data_rules
    # static page
  end

  private

  def file
    params[:file]
  end

  def redirect_to_new_password_path
    if current_user.aws_status == 'FORCE_NEW_PASSWORD'
      redirect_to new_password_path
    end
  end

  def check_job_uuid
    if session[:job_uuid].nil?
      Rails.logger.error 'Job identifier is missing'
      redirect_to root_path
    end
  end

  def handle_job(result)
    if result.success?
      redirect_to success_upload_index_path
    elsif result.invalid_csv?
      flash[:custom_error] = 'Uploaded file is not valid'
      redirect_to upload_index_path, alert: result.errors
    else
      flash[:custom_error] = "Can't start validation"
      redirect_to upload_index_path, alert: result.errors
    end
  end
end
