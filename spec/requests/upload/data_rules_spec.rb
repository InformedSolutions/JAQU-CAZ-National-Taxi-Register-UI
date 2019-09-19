# frozen_string_literal: true

require 'rails_helper'

describe 'UploadController - GET #data_rules', type: :request do
  subject(:http_request) { get data_rules_upload_index_path }

  before { sign_in new_user }

  it 'returns a success response' do
    http_request
    expect(response).to have_http_status(:success)
  end
end
