# frozen_string_literal: true

##
# Class used to create email sent to the user during CSV upload process
#
class UploadMailer < ApplicationMailer
  ##
  # Action sending an email to the user after successful file upload
  #
  # ==== Attributes
  #
  # * +user+ - an instance of {User class}[rdoc-ref:User] with an email address set
  #
  # ==== Usage
  #
  #    user = User.new
  #    user.email = 'test@example.com'
  #    UploadMailer.success_upload(user).deliver
  #
  def success_upload(user)
    mail(to: user.email, subject: 'Upload successful')
  end
end
