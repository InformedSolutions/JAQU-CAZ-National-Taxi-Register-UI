# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - POST #submit_search' do
  subject { post search_vehicles_path, params: params }

  let(:params) do
    {
      search: {
        vrn: vrn,
        historic: historic,
        start_date_day: start_date_day,
        start_date_month: start_date_month,
        start_date_year: start_date_year,
        end_date_day: end_date_day,
        end_date_month: end_date_month,
        end_date_year: end_date_year
      }
    }
  end
  let(:vrn) { 'CU57ABC' }
  let(:historic) { 'false' }
  let(:start_date_day) { '10' }
  let(:start_date_month) { '3' }
  let(:start_date_year) { '2020' }
  let(:end_date_day) { '14' }
  let(:end_date_month) { '3' }
  let(:end_date_year) { '2020' }

  context 'user belongs to proper group' do
    before do
      sign_in create_user
      subject
    end

    context 'when VRN is valid' do
      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'redirect to search results page' do
        expect(response).to redirect_to(vehicles_path)
      end
    end

    context 'when chosen historic search' do
      let(:historic) { 'true' }

      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to the historic results page' do
        expect(response).to redirect_to(historic_search_vehicles_path)
      end
    end

    context 'when VRN is not valid' do
      let(:vrn) { '' }

      it 'renders search page' do
        expect(response).to render_template(:search)
      end
    end
  end

  it_behaves_like 'user does not belongs to any group'
end
