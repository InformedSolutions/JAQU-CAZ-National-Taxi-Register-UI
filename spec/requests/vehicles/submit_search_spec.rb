# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - POST #submit_search', type: :request do
  subject(:http_request) { post search_vehicles_path, params: { vrn: vrn } }

  let(:vrn) { 'CU57ABC' }

  before do
    sign_in create_user
    http_request
  end

  context 'when VRN is valid' do
    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end

    it 'redirect to search results page' do
      expect(response).to redirect_to(vehicles_path)
    end
  end

  context 'when VRN is not valid' do
    let(:vrn) { '' }

    it 'renders search page' do
      expect(response).to render_template(:search)
    end
  end
end
