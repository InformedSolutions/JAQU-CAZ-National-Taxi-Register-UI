# frozen_string_literal: true

class UploadController < ApplicationController
  before_action :authenticate_user!

  def import
    CsvUploadService.call(file: file)
  end

  def data_rules; end

  private

  def file
    params[:file]
  end
end
