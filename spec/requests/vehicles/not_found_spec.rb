# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #not_found', type: :request do
  subject { get not_found_vehicles_path }

  context 'user belongs to proper group' do
    before do
      sign_in create_user
      add_to_session(vrn: 'CU57ABC')
      subject
    end

    it 'returns ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders not found page' do
      expect(response).to render_template(:not_found)
    end
  end

  it_behaves_like 'user does not belongs to any group'
end
