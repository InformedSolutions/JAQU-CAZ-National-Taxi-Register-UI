# frozen_string_literal: true

module Aws
  module Plugins
    class Logging < Seahorse::Client::Plugin
      # monkey patch for class in `aws-sdk-cognitoidentityprovider` gem
      class Handler < Seahorse::Client::Handler
        private

        # Do not log Aws::CognitoIdentityProvider::Client, AWS::SES and AWS:S3 responses
        # by the reason that we should not see sensitive parameters in logs
        def log(config, response)
          return if %w[cognito-idp ses s3].include?(config.sigv4_signer.service)

          config.logger.send(config.log_level, format(config, response))
        end
      end
    end
  end
end
