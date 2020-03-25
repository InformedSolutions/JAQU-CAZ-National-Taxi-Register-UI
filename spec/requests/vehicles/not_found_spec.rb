# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #not_found', type: :request do
  subject(:http_request) { get not_found_vehicles_path }

  before do
    sign_in create_user
    add_to_session(vrn: 'CU57ABC')
    http_request
  end

  it 'returns ok status' do
    expect(response).to be_successful
  end

  it 'renders not found page' do
    expect(response).to render_template(:not_found)
  end
end
