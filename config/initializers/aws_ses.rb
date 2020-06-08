# frozen_string_literal: true

creds = if ENV['S3_AWS_ACCESS_KEY_ID']
          Aws::Credentials.new(
            ENV.fetch('SES_ACCESS_KEY_ID', 'SES_ACCESS_KEY_ID'),
            ENV.fetch('SES_SECRET_ACCESS_KEY', 'SES_SECRET_ACCESS_KEY')
          )
        else
          Aws::ECSCredentials.new({ ip_address: '169.254.170.2' })
        end

# default to Ireland, as SES is not supported in London
region = ENV.fetch('SES_REGION', 'eu-west-1')

Aws::Rails.add_action_mailer_delivery_method(:aws_sdk, credentials: creds, region: region)
