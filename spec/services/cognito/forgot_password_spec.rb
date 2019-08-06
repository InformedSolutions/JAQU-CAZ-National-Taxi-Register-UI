# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cognito::ForgotPassword do
  subject(:service_call) { described_class.call(username: username) }

  let(:username) { 'wojtek' }
  let(:cognito_response) { true }
  let(:form) { OpenStruct.new(valid?: true) }

  before do
    allow(COGNITO_CLIENT).to receive(:forgot_password).with(
      client_id: anything,
      username: username
    ).and_return(cognito_response)

    allow(ResetPasswordForm).to receive(:new).with(username).and_return(form)
  end

  context 'when form is valid and cognito returns 200' do
    it 'returns true' do
      expect(service_call).to be_truthy
    end

    it 'calls ResetPasswordForm' do
      expect(ResetPasswordForm).to receive(:new).with(username)
      service_call
    end

    it 'calls Cognito' do
      expect(COGNITO_CLIENT).to receive(:forgot_password)
      service_call
    end
  end

  context 'when form is invalid' do
    let(:cognito_response) { true }
    let(:form) { OpenStruct.new(valid?: false, message: error) }
    let(:error) { 'Something went wrong' }

    it 'raises exception with proper params' do
      expect { service_call }.to raise_exception(Cognito::CallException, error) { |ex|
        ex.path == '/passwords/reset'
      }
    end
  end

  context 'when Cognito call fails' do
    let(:form) { OpenStruct.new(valid?: true) }

    it 'raises exception with proper params' do
      allow(COGNITO_CLIENT).to receive(:forgot_password).with(
        client_id: anything,
        username: username
      ).and_raise(
        Aws::CognitoIdentityProvider::Errors::ServiceError.new('', '')
      )

      expect { service_call }.to raise_exception(Cognito::CallException, 'Something went wrong')
    end
  end
end
