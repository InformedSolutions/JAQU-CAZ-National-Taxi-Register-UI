# frozen_string_literal: true

##
# Base class for mailers. Sets default from value and layout
#
class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SES_FROM_EMAIL', 'TaxiandPHVCentralised.Database@defra.gov.uk')
  layout 'mailer'
end
