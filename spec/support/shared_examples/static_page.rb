# frozen_string_literal: true

RSpec.shared_examples 'a static page' do
  it 'returns a success response' do
    http_request
    expect(response).to have_http_status(:success)
  end
end
