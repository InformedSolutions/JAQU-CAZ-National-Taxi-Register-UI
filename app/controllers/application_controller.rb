# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CsvUploadFailureException, with: :handle_exception

  private

  def handle_exception(exception)
    redirect_to(upload_index_path, alert: exception.response[:errors])
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(_resource_or_scope)
    user_session_path
  end
end
