# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def reset_password
    assign_error
  end

  def update_password
    assign_error
    form = EmailForm.new(email)
    unless form.valid?
      redirect_to reset_password_path(error: form.message, email: email)
      return
    end
  end

  def password_updated
    form = UpdatePasswordForm.new(params)
    unless form.valid?
      redirect_to update_password_path(error: form.message,
                                       error_type: form.error_input,
                                       email: email,
                                       confirmation_code: confirmation_code)
      return
    end
  end

  private

  def assign_error
    @error_message = params[:error]
    @error_type = params[:error_type] if params[:error_type].present?
  end

  def email
    params[:email]
  end

  def confirmation_code
    params[:confirmation_code]
  end

  def password
    params[:password]
  end

  def password_confirmation
    params[:password_confirmation]
  end
end
