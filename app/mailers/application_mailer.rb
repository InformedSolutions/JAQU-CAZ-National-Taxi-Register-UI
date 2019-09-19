# frozen_string_literal: true

##
# Base class for mailers. Sets default from value and layout
#
class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.service_email
  layout 'mailer'
end
