# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #success' do
  subject { get success_passwords_path }

  context 'when user is logged in' do
    before do
      sign_in create_user
      subject
    end

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when user is not logged in' do
    before { subject }

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end
  end
end
