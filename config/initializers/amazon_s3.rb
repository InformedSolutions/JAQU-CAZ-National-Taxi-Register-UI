# frozen_string_literal: true

creds = if Rails.env.production?
          Aws::ECSCredentials.new(ip_address: '169.254.170.2')
        else
          Aws::Credentials.new(
            ENV.fetch('S3_AWS_ACCESS_KEY_ID', 'S3_AWS_ACCESS_KEY_ID'),
            ENV.fetch('S3_AWS_SECRET_ACCESS_KEY', 'S3_AWS_SECRET_ACCESS_KEY')
          )
        end

AMAZON_S3_CLIENT = Aws::S3::Resource.new(
  region: ENV.fetch('S3_AWS_REGION', 'S3_AWS_REGION'),
  credentials: creds
)
