# frozen_string_literal: true

class UploadController < ApplicationController
  before_action :authenticate_user!

  def import
    file_name = CsvUploadService.call(file: file, user: current_user)
    redirect_to processing_upload_index_path(file_name: file_name)
  end

  def processing; end

  def data_rules; end

  private

  def file
    params[:file]
  end
end
