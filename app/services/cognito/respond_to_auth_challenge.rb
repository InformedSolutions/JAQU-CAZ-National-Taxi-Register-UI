# frozen_string_literal: true

module Cognito
  class RespondToAuthChallenge < BaseService
    attr_reader :user, :password

    def initialize(user:, password:)
      @user = user
      @password = password
    end

    def call
      response = respond_to_auth
      update_user(response.authentication_result.access_token)
      user
    end

    private

    def update_user(access_token)
      @user = Cognito::GetUser.call(access_token: access_token, user: user)
    end

    def respond_to_auth
      COGNITO_CLIENT.respond_to_auth_challenge(
        challenge_name: 'NEW_PASSWORD_REQUIRED',
        client_id: ENV['AWS_COGNITO_CLIENT_ID'],
        session: user.aws_session,
        challenge_responses: {
          'NEW_PASSWORD' => password,
          'USERNAME' => user.username
        }
      )
    end
  end
end
