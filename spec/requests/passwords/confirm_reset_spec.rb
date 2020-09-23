# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #confirm_reset' do
  subject { get confirm_reset_passwords_path }

  let(:username) { 'wojtek@example.com' }

  context 'with password_reset_token set' do
    before do
      inject_session(
        password_reset_token: SecureRandom.uuid,
        password_reset_username: username
      )
    end

    it 'returns a 200 OK status' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  context 'without password_reset_token set' do
    it 'returns redirect to success page' do
      subject
      expect(response).to redirect_to(success_passwords_path)
    end
  end

  context 'without password_reset_username set' do
    before do
      inject_session(password_reset_token: SecureRandom.uuid)
    end

    it 'returns redirect to login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
