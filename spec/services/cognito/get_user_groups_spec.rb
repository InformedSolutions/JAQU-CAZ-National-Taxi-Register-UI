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
      service_call
      expect(Cognito::Client.instance).to have_received(:admin_list_groups_for_user).with(
        user_pool_id: anything,
        username: username
      )
    end
  end
end
