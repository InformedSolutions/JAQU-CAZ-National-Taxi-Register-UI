# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cognito::RespondToAuthChallenge do
  subject(:service_call) { described_class.call(user: user, password: password) }

  let(:password) { 'password' }
  let(:user) do
    user = User.new
    user.username = 'wojtek'
    user.aws_session = SecureRandom.uuid
    user
  end
  let(:cognito_user) do
    user = User.new
    user.username = 'wojciech'
    user
  end
  let(:auth_response) do
    OpenStruct.new(authentication_result: OpenStruct.new(access_token: token))
  end
  let(:token) { SecureRandom.uuid }

  before do
    allow(Cognito::GetUser).to receive(:call)
      .with(access_token: token, user: user)
      .and_return(cognito_user)
    allow(COGNITO_CLIENT).to receive(:respond_to_auth_challenge)
      .with(
        challenge_name: 'NEW_PASSWORD_REQUIRED',
        client_id: anything,
        session: user.aws_session,
        challenge_responses: {
          'NEW_PASSWORD' => password,
          'USERNAME' => user.username
        }
      ).and_return(auth_response)
  end

  it 'returns a cggnito user' do
    expect(service_call).to eq(cognito_user)
  end
end
