# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CsvUploadFailureException, with: :handle_exception

  def health
    render json: 'OK', status: 200
  end

  private

  def handle_exception(exception)
    redirect_to(upload_index_path, alert: exception.response[:errors])
  end
end
