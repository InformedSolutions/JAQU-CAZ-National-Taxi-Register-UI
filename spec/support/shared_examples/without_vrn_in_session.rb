# frozen_string_literal: true

RSpec.shared_examples 'vrn is missing' do
  it 'redirects to search path' do
    expect(response).to redirect_to(search_vehicles_path)
  end
end
