# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #confirm_reset', type: :request do
  subject(:http_request) { get confirm_reset_passwords_path, params: params }

  let(:params) { { username: 'wojtek' } }

  it 'returns 200' do
    http_request
    expect(response).to be_successful
  end
end
