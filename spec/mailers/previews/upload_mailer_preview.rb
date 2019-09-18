# frozen_string_literal: true

##
# Preview all emails at http://localhost:3000/rails/mailers/upload_mailer
#
class UploadMailerPreview < ActionMailer::Preview
  def success_upload
    user = User.new
    user.email = 'test@example.com'
    UploadMailer.success_upload(user)
  end
end
