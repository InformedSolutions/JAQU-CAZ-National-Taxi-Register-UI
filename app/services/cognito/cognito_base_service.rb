# frozen_string_literal: true

module Cognito
  class CognitoBaseService < BaseService
    AWS_ERROR = Aws::CognitoIdentityProvider::Errors

    def log_successful_call
      log_action 'The call was successful'
    end

    def log_invalid_params(msg)
      Rails.logger.error "[#{self.class.name}] Invalid form params - #{msg}"
    end
  end
end
