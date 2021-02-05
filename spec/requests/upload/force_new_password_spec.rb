# frozen_string_literal: true

require 'rails_helper'

describe 'UploadController - #force_new_password', type: :request do
  subject { get root_path }

  let(:user) { create_user(aws_status: 'FORCE_NEW_PASSWORD') }

  before do
    sign_in user
    subject
  end

  context 'when user aws_status is FORCE_NEW_PASSWORD' do
    it 'redirects to new password path' do
      expect(response).to redirect_to(new_password_path)
    end
  end
end
