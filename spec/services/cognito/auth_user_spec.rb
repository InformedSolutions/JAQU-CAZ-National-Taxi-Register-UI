# frozen_string_literal: true

require 'rails_helper'

describe Cognito::AuthUser do
  subject(:service_call) do
    described_class.call(username: username, password: password, login_ip: remote_ip)
  end

  let(:username) { 'user@example.com' }
  let(:password) { 'password' }
  let(:remote_ip) { '1.2.3.4' }
  let(:auth_params) do
    {
      client_id: anything,
      auth_flow: 'USER_PASSWORD_AUTH',
      auth_parameters:
          {
            'USERNAME' => username,
            'PASSWORD' => password
          }
    }
  end

  context 'with successful call' do
    before do
      allow(Cognito::Client.instance).to receive(:initiate_auth).with(auth_params).and_return(auth_response)
      allow(Cognito::Client.instance).to receive(:admin_list_groups_for_user).with(
        user_pool_id: anything,
        username: username
      ).and_return(OpenStruct.new(groups: [OpenStruct.new(group_name: 'ntr.search.dev')]))
    end

    context 'when user changed the password' do
      let(:auth_response) { OpenStruct.new(authentication_result: OpenStruct.new(access_token: token)) }
      let(:token) { SecureRandom.uuid }

      before do
        allow(Cognito::GetUser).to receive(:call).and_return(User.new)
        user_groups_response = OpenStruct.new(groups: [OpenStruct.new(group_name: 'ntr.search.dev')])
        allow(Cognito::GetUser).to receive(:call).and_return(user_groups_response)
        allow(Cognito::GetUserGroups).to receive(:call).and_return(user_groups_response)
      end

      it 'calls `Cognito::GetUser`' do
        service_call
        expect(Cognito::GetUser).to have_received(:call)
          .with(access_token: token, username: username, user: an_instance_of(User))
      end

      it 'calls `Cognito::GetUserGroups`' do
        service_call
        expect(Cognito::GetUserGroups).to have_received(:call).with(username: username)
      end
    end

    context 'when user did not change the password' do
      let(:email) { 'test@example.com' }
      let(:session_key) { SecureRandom.uuid }
      let(:auth_response) do
        OpenStruct.new(challenge_parameters: {
                         'USER_ID_FOR_SRP' => username,
                         'userAttributes' => { 'email' => email }.to_json
                       }, session: session_key)
      end

      it 'returns an instance of the user class' do
        expect(service_call).to be_a(User)
      end

      it 'sets user email' do
        expect(service_call.email).to eq(email)
      end

      it 'sets username' do
        expect(service_call.username).to eq(username)
      end

      it 'sets aws_status to FORCE_NEW_PASSWORD' do
        expect(service_call.aws_status).to eq('FORCE_NEW_PASSWORD')
      end

      it 'sets aws_session' do
        expect(service_call.aws_session).to eq(session_key)
      end

      it 'sets hashed password' do
        expect(service_call.hashed_password).to eq(Digest::MD5.hexdigest(password))
      end

      it 'sets login_ip' do
        expect(service_call.login_ip).to eq(remote_ip)
      end

      it 'sets groups' do
        expect(service_call.groups).to eq(%w[ntr.search.dev])
      end
    end
  end

  context 'when `initiate_auth` call raises exception' do
    before do
      allow(Cognito::Client.instance).to receive(:initiate_auth)
        .and_raise(
          Aws::CognitoIdentityProvider::Errors::NotAuthorizedException.new('', 'error')
        )
    end

    it 'returns false' do
      expect(service_call).to be_falsey
    end
  end

  context 'when `admin_list_groups_for_user` call raises exception' do
    before do
      token = SecureRandom.uuid
      allow(Cognito::Client.instance).to receive(:initiate_auth)
        .with(auth_params)
        .and_return(OpenStruct.new(authentication_result: OpenStruct.new(access_token: token)))

      allow(Cognito::Client.instance).to receive(:admin_list_groups_for_user)
        .and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('', 'error'))
      allow(Cognito::GetUser).to receive(:call).and_return(User.new)
    end

    it 'returns false' do
      expect(service_call).to be_falsey
    end
  end
end
