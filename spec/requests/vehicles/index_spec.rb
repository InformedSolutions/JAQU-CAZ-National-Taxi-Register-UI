# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #index', type: :request do
  subject(:http_request) { get vehicles_path }

  let(:vrn) { 'CU57ABC' }

  before do
    sign_in create_user
  end

  context 'with VRN in the session' do
    before do
      response = read_response_file('licence_info_response.json')
      allow(VehiclesCheckerApi).to receive(:licence_info).with(vrn).and_return(response)
      add_to_session(vrn: vrn)
      http_request
    end

    it 'returns ok status' do
      expect(response).to be_successful
    end

    it 'renders index page' do
      expect(response).to render_template(:index)
    end
  end

  context 'without VRN in the session' do
    before do
      http_request
    end

    it_behaves_like 'vrn is missing'
  end

  context 'when VRN can not be found' do
    before do
      service = BaseApi::Error404Exception
      allow(VehiclesCheckerApi).to receive(:licence_info).with(vrn).and_raise(
        service.new(404, 'VRN number was not found', {})
      )
      add_to_session(vrn: vrn)
      http_request
    end

    it 'redirects to not found path' do
      expect(response).to redirect_to(not_found_vehicles_path)
    end
  end
end
