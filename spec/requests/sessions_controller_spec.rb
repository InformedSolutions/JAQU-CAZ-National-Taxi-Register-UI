# frozen_string_literal: true

require 'rails_helper'

describe 'SessionsController - DELETE #destroy', type: :request do
  subject { delete destroy_user_session_url }

  before do
    sign_in create_user
    subject
  end

  it 'redirects to the sign in page' do
    expect(response).to redirect_to(user_session_path)
  end
end
