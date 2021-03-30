# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #reset', type: :request do
  subject { get reset_passwords_path }

  let(:user) { User.new }

  it 'returns a 200 OK status' do
    subject
    expect(response).to have_http_status(:ok)
  end

  it 'sets password_reset_token' do
    subject
    expect(session[:password_reset_token]).not_to be_nil
  end
end
