# frozen_string_literal: true

class UploadMailer < ApplicationMailer
  def success_upload(user)
    mail(to: user.email, subject: 'Upload successful')
  end
end
