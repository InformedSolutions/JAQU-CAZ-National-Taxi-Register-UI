# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #new', type: :request do
  subject(:http_request) { get new_password_path }

  let(:user) { User.new }

  before do
    sign_in user
    http_request
  end

  context 'when user aws_status is OK' do
    let(:user) do
      user = User.new
      user.aws_status = 'OK'
      user
    end

    it 'returns a redirect to root_path' do
      expect(response).to redirect_to(root_path)
    end
  end

  context 'when user aws_session is missing' do
    let(:user) do
      user = User.new
      user.aws_status = 'FORCE_NEW_PASSWORD'
      user
    end

    it 'returns a redirect to new_user_session_path' do
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'with valid params' do
    let(:user) do
      user = User.new
      user.aws_status = 'FORCE_NEW_PASSWORD'
      user.aws_session = SecureRandom.uuid
      user
    end

    it 'returns 200' do
      expect(response).to be_successful
    end
  end
end
