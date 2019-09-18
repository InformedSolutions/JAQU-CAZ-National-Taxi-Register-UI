# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SES_FROM_EMAIL', 'TaxiandPHVCentralised.Database@defra.gov.uk')
  layout 'mailer'
end
