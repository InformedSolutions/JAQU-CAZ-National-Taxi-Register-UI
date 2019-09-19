# frozen_string_literal: true

require 'rails_helper'

describe 'UploadController - GET #success', type: :request do
  subject(:http_request) { get success_upload_index_path }

  let(:user) { new_user(email: 'test@example.com') }

  before { sign_in user }

  context 'with empty session' do
    it 'returns 200' do
      http_request
      expect(response).to be_successful
    end

    it 'does not call Ses::SendSuccessEmail' do
      expect(Ses::SendSuccessEmail).not_to receive(:call)
      http_request
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

      it 'returns 200' do
        http_request
        expect(response).to be_successful
      end

      it 'calls Ses::SendSuccessEmail' do
        expect(Ses::SendSuccessEmail).to receive(:call).with(user: user, job_data: job_data)
        http_request
      end

      it 'clears job data from the session' do
        http_request
        expect(session[:job]).to be_nil
      end

      it 'deos not render the warning' do
        http_request
        expect(response.body).not_to include(I18n.t('upload.delivery_error'))
      end
    end

    context 'with unsuccessful call to Ses::SendSuccessEmail' do
      before do
        allow(Ses::SendSuccessEmail).to receive(:call).and_return(false)
        http_request
      end

      it 'returns 200' do
        expect(response).to be_successful
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
