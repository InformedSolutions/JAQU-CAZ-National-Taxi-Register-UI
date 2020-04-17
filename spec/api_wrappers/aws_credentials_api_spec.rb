# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwsCredentialsApi do
  describe '.fetch_credentials' do
    subject(:api_call) { described_class.fetch_credentials }

    let(:aws_response) do
      {
        'AccessKeyId' => 'ACCESS_KEY_ID',
        'Expiration' => 'EXPIRATION_DATE',
        'RoleArn' => 'TASK_ROLE_ARN',
        'SecretAccessKey' => 'SECRET_ACCESS_KEY',
        'Token' => 'SECURITY_TOKEN_STRING'
      }
    end

    before do
      stub_request(:get, %r{169.254.170.2/credentials})
        .to_return(status: 200, body: aws_response.to_json)
    end

    it 'returns job name' do
      expect(api_call).to eq(aws_response)
    end

    it 'returns AccessKeyId' do
      expect(api_call['AccessKeyId']).to eq('ACCESS_KEY_ID')
    end

    it 'returns SecretAccessKey' do
      expect(api_call['SecretAccessKey']).to eq('SECRET_ACCESS_KEY')
    end
  end
end
