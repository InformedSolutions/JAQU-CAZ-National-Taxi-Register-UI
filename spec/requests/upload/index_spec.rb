# frozen_string_literal: true

require 'rails_helper'

describe 'UploadController - GET #index', type: :request do
  subject(:http_request) { get authenticated_root_path }

  let(:file_path) do
    File.join(
      'spec',
      'fixtures', 'files', 'csv', 'CAZ-2020-01-08-AuthorityID-1.csv'
    )
  end

  before { sign_in new_user }

  it 'returns a success response' do
    http_request
    expect(response).to have_http_status(:success)
  end

  context 'when session[:job] is set' do
    let(:correlation_id) { SecureRandom.uuid }
    let(:job_name) { 'name' }

    before do
      inject_session(job: { name: job_name, correlation_id: correlation_id })
      allow(RegisterCheckerApi).to receive(:job_errors).and_return(['error'])
    end

    it 'calls RegisterCheckerApi.job_errors' do
      expect(RegisterCheckerApi).to receive(:job_errors).with(job_name, correlation_id)
      http_request
    end

    it 'clears job from session' do
      http_request
      expect(session[:job]).to be_nil
    end
  end
end
