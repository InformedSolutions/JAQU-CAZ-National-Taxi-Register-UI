# frozen_string_literal: true

require 'rails_helper'

describe 'ApplicationController - GET #build_id', type: :request do
  subject { get build_id_path }

  it 'returns a 200 OK status' do
    subject
    expect(response).to have_http_status(:ok)
  end

  it 'returns undefined' do
    subject
    expect(response.body).to eq('undefined')
  end

  context 'when BUILD_ID is defined' do
    let(:build_id) { '50.0' }

    before { allow(ENV).to receive(:fetch).with('BUILD_ID', 'undefined').and_return(build_id) }

    it 'returns BUILD_ID' do
      subject
      expect(response.body).to eq(build_id)
    end
  end
end
