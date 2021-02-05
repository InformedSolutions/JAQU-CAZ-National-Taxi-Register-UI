# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #index', type: :request do
  subject { get vehicles_path }

  context 'user belongs to proper group' do
    let(:vrn) { 'CU57ABC' }

    before { sign_in create_user }

    context 'with VRN in the session' do
      before do
        response = read_response_file('licence_info_response.json')
        allow(VehiclesCheckerApi).to receive(:licence_info).with(vrn).and_return(response)
        add_to_session(vrn: vrn)
        subject
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders index page' do
        expect(response).to render_template(:index)
      end
    end

    context 'without VRN in the session' do
      before { subject }

      it_behaves_like 'vrn is missing'
    end

    context 'when VRN can not be found' do
      before do
        allow(VehiclesCheckerApi).to receive(:licence_info).with(vrn).and_raise(
          BaseApi::Error404Exception.new(404, 'VRN number was not found', {})
        )
        add_to_session(vrn: vrn)
        subject
      end

      it 'redirects to not found path' do
        expect(response).to redirect_to(not_found_vehicles_path)
      end
    end

    context 'and api returns 400 status' do
      before do
        allow(VehiclesCheckerApi).to receive(:licence_info).with(vrn).and_raise(
          BaseApi::Error400Exception.new(400, '', {})
        )
        add_to_session(vrn: vrn)
        subject
      end

      it 'renders the service unavailable page' do
        expect(subject).to render_template('errors/service_unavailable')
      end
    end
  end

  it_behaves_like 'user does not belongs to any group'
end
