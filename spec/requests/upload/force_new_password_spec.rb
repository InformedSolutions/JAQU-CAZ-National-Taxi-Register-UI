# frozen_string_literal: true

require 'rails_helper'

describe 'UploadController - #force_new_password', type: :request do
  subject(:http_request) { get root_path }

  let(:user) { new_user(aws_status: 'FORCE_NEW_PASSWORD') }

  before do
    sign_in user
    http_request
  end

  context 'when user aws_status is FORCE_NEW_PASSWORD' do
    it 'redirects to new password path' do
      expect(response).to redirect_to(new_password_path)
    end
  end
end
