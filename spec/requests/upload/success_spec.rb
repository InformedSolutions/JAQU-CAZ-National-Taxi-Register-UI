# frozen_string_literal: true

require 'rails_helper'

describe 'UploadController - GET #success', type: :request do
  subject { get success_upload_index_path }

  let(:user) { create_user }

  before { sign_in user }

  context 'with empty session' do
    before do
      allow(Ses::SendSuccessEmail).to receive(:call)
      subject
    end

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'does not call Ses::SendSuccessEmail' do
      expect(Ses::SendSuccessEmail).not_to have_received(:call)
    end
  end

  context 'with job data is session' do
    let(:filename) { 'name.csv' }
    let(:time) { Time.current }
    let(:job_data) do
      {
        name: 'name',
        filename: filename,
        correlation_id: SecureRandom.uuid,
        submission_time: time
      }
    end

    before { inject_session(job: job_data) }

    context 'with successful call to Ses::SendSuccessEmail' do
      before { allow(Ses::SendSuccessEmail).to receive(:call).and_return(true) }

      it 'returns a 200 OK status' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'calls Ses::SendSuccessEmail' do
        subject
        expect(Ses::SendSuccessEmail).to have_received(:call).with(user: user, job_data: job_data)
      end

      it 'clears job data from the session' do
        subject
        expect(session[:job]).to be_nil
      end

      it 'deos not render the warning' do
        subject
        expect(response.body).not_to include(I18n.t('upload.delivery_error'))
      end
    end

    context 'with unsuccessful call to Ses::SendSuccessEmail' do
      before do
        allow(Ses::SendSuccessEmail).to receive(:call).and_return(false)
        subject
      end

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'clears job data from the session' do
        expect(session[:job]).to be_nil
      end

      it 'renders the warning' do
        expect(response.body).to include(I18n.t('upload.delivery_error'))
      end
    end
  end
end
