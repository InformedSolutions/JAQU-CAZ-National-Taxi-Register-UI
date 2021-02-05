# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #historic_search', type: :request do
  subject { get historic_search_vehicles_path }

  context 'user belongs to proper group' do
    before do
      add_to_session(vrn: 'CU57ABC')
      mock_vrn_history
      sign_in create_user
      subject
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the view' do
      expect(response).to render_template(:historic_search)
    end
  end

  it_behaves_like 'user does not belongs to any group'
end

private

def mock_vrn_history
  allow(HistoricalVrnDetails).to receive(:new).and_return(create_history)
end

def create_history
  instance_double(HistoricalVrnDetails,
                  pagination: paginated_history,
                  total_changes_count_zero?: false,
                  changes_empty?: false)
end

def mocked_changes
  vehicles_data = read_response_file('licence_info_historical_response.json')['1']['changes']
  vehicles_data.map { |data| VrnHistory.new(data) }
end

def paginated_history
  instance_double(
    PaginatedVrnHistory,
    vrn_changes_list: mocked_changes,
    page: 1,
    total_pages: 2,
    range_start: 1,
    range_end: 10,
    total_changes_count: 12
  )
end
