# frozen_string_literal: true

require 'rails_helper'

describe 'User forgot password', type: :request do
  let(:email) { 'user@example.com' }
  let(:confirmation_code) { '1234' }
  let(:password) { '12345678' }
  let(:password_confirmation) { '12345678' }
  let(:params) do
    {
      email: email,
      confirmation_code: confirmation_code,
      password: password,
      password_confirmation: password_confirmation
    }
  end

  describe 'requesting reset password page' do
    subject(:http_request) { get reset_password_path }

    it 'redirects to reset password page' do
      http_request
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'requesting update password page' do
    subject(:http_request) { get update_password_path(email: email) }

    it 'redirects to update password page' do
      http_request
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'requesting password updated page' do
    subject(:http_request) { get password_updated_path(params) }

    it 'redirects to password updated page' do
      http_request
      expect(response).to have_http_status(:ok)
    end
  end
end
