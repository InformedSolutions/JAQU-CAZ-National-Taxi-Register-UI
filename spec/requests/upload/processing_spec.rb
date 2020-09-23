# frozen_string_literal: true

require 'rails_helper'

describe 'UploadController - GET #processing' do
  subject { get processing_upload_index_path }

  let(:job_status) { 'SUCCESS' }
  let(:correlation_id) { SecureRandom.uuid }
  let(:job_name) { 'name' }
  let(:job_data) { { name: job_name, correlation_id: correlation_id } }

  before { sign_in create_user }

  context 'with valid job data' do
    before do
      inject_session(job: job_data)
      allow(RegisterCheckerApi).to receive(:job_status).and_return(job_status)
      subject
    end

    context 'when job status is SUCCESS' do
      it 'returns a redirect to success page' do
        expect(response).to redirect_to(success_upload_index_path)
      end
    end

    context 'when job status is RUNNING' do
      let(:job_status) { 'RUNNING' }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'does not clear job from session' do
        subject
        expect(session[:job]).to eq(job_data)
      end
    end

    context 'when job status is FAILURE' do
      let(:job_status) { 'FAILURE' }

      it 'returns a redirect to upload page' do
        expect(response).to redirect_to(authenticated_root_path)
      end

      it 'does not clear job from session' do
        subject
        expect(session[:job]).to eq(job_data)
      end
    end
  end

  context 'with missing job data' do
    it 'returns a redirect to root page' do
      subject
      expect(response).to redirect_to(root_path)
    end
  end
end
