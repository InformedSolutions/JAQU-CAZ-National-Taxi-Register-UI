# frozen_string_literal: true

require 'rails_helper'

describe Cognito::GetUserGroups do
  subject(:service_call) { described_class.call(username: username) }

  let(:username) { 'user@example.com' }

  before do
    allow(Cognito::Client.instance).to receive(:admin_list_groups_for_user).with(
      user_pool_id: anything,
      username: username
    ).and_return(true)
  end

  context 'with successful call' do
    it 'calls Cognito with proper params and returns true' do
      expect(Cognito::Client.instance).to receive(:admin_list_groups_for_user).with(
        user_pool_id: anything,
        username: username
      ).and_return(true)
      service_call
    end
  end
end
