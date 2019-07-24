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
    result = Connection::RegisterCheckerApi.check_job_status(session[:job_uuid])
    if result == 'RUNNING'
    elsif result == 'FINISHED_OK_NO_ERRORS'
      session[:job_uuid] = nil
      redirect_to success_upload_index_path
    else
      session[:job_uuid] = nil
      redirect_to upload_index_path, alert: result
    end
  end

  def data_rules; end

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
end
