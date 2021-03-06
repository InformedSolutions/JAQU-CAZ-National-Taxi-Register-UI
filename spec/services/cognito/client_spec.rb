# frozen_string_literal: true

require 'rails_helper'

describe Cognito::Client do
  subject(:service) do
    Class.new described_class
  end

  let(:aws_cognito_client) { Aws::CognitoIdentityProvider::Client.new }

  before do
    allow(Aws::CognitoIdentityProvider::Client).to(
      receive(:new).and_return(aws_cognito_client)
    )
  end

  context 'When cognito client raise ResourceNotFoundException' do
    before do
      allow(aws_cognito_client).to(receive(:list_users)).and_raise(
        Aws::CognitoIdentityProvider::Errors::ResourceNotFoundException.new('', 'error')
      )
    end

    # rubocop:disable RSpec/MessageSpies
    it 'retries to call after credentials rotation' do
      expect(aws_cognito_client).to receive(:list_users).twice
      begin
        service.instance.list_users
      rescue Aws::CognitoIdentityProvider::Errors::ResourceNotFoundException # rubocop:disable Lint/SuppressedException
      end
    end
    # rubocop:enable RSpec/MessageSpies
  end

  context 'When cognito client raise UnrecognizedClientException' do
    before do
      allow(aws_cognito_client).to(receive(:list_users)).and_raise(
        Aws::CognitoIdentityProvider::Errors::UnrecognizedClientException.new('', 'error')
      )
    end

    # rubocop:disable RSpec/MessageSpies
    it 'retries to call after credentials rotation' do
      expect(aws_cognito_client).to receive(:list_users).twice
      begin
        service.instance.list_users
      rescue Aws::CognitoIdentityProvider::Errors::UnrecognizedClientException # rubocop:disable Lint/SuppressedException
      end
    end
    # rubocop:enable RSpec/MessageSpies
  end

  context 'When cognito client raise other exception' do
    before do
      allow(aws_cognito_client).to(receive(:list_users)).and_raise(
        Aws::CognitoIdentityProvider::Errors::UserNotFoundException.new('', 'error')
      )
    end

    # rubocop:disable RSpec/MessageSpies
    it 'does not retries the call' do
      expect(aws_cognito_client).to receive(:list_users).once
      begin
        service.instance.list_users
      rescue Aws::CognitoIdentityProvider::Errors::UserNotFoundException # rubocop:disable Lint/SuppressedException
      end
    end
    # rubocop:enable RSpec/MessageSpies
  end

  context 'When cognito client not exception' do
    let(:users) { %w[user1 user2] }

    before do
      allow(aws_cognito_client).to(receive(:list_users)).and_return(users)
    end

    it 'returns the result frotm the AWS' do
      response = service.instance.list_users
      expect(response).to equal(users)
    end

    it 'calls AWS only once' do
      service.instance.list_users
      expect(aws_cognito_client).to have_received(:list_users).once
    end
  end
end
