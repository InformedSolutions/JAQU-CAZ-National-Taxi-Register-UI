# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #search', type: :request do
  subject(:http_request) { get search_vehicles_path }

  before do
    sign_in create_user
    http_request
  end

  it 'returns a success response' do
    expect(response).to have_http_status(:success)
  end
end
