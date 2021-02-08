# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #search', type: :request do
  subject { get search_vehicles_path }

  context 'user belongs to proper group' do
    before do
      sign_in create_user
      subject
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

  it_behaves_like 'user does not belongs to any group'
end
