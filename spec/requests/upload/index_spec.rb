# frozen_string_literal: true

require 'rails_helper'

describe 'UploadController - GET #index', type: :request do
  subject { get authenticated_root_path }

  let(:file_path) do
    File.join(
      'spec',
      'fixtures', 'files', 'csv', 'CAZ-2020-01-08-AuthorityID.csv'
    )
  end
  let(:user) { create_user }

  before { sign_in user }

  it 'returns a success response' do
    subject
    expect(response).to have_http_status(:success)
  end

  context 'when session[:job] is set' do
    let(:correlation_id) { SecureRandom.uuid }
    let(:job_name) { 'name' }

    before do
      inject_session(job: { name: job_name, correlation_id: correlation_id })
      allow(RegisterCheckerApi).to receive(:job_errors).and_return(%w[error])
    end

    it 'calls RegisterCheckerApi.job_errors' do
      subject
      expect(RegisterCheckerApi).to have_received(:job_errors).with(job_name, correlation_id)
    end

    it 'clears job from session' do
      subject
      expect(session[:job]).to be_nil
    end
  end

  context 'when user login IP does not match request IP' do
    let(:user) { create_user(login_ip: '0.0.0.0') }

    it 'returns a redirect to login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'logs out the user' do
      subject
      expect(controller.current_user).to be_nil
    end
  end
end
