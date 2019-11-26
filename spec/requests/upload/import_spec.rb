# frozen_string_literal: true

require 'rails_helper'

describe 'UploadController - POST #import' do
  subject(:http_request) { post import_upload_index_path, params: { file: csv_file } }

  let(:file_path) do
    File.join(
      'spec',
      'fixtures', 'files', 'csv', 'CAZ-2020-01-08-AuthorityID.csv'
    )
  end
  let(:csv_file) { fixture_file_upload(file_path) }

  before(:each) { sign_in new_user }

  context 'with valid params' do
    let(:job_name) { 'name' }

    before do
      allow(CsvUploadService).to receive(:call).and_return(true)
      allow(RegisterCheckerApi).to receive(:register_job).and_return(job_name)
      http_request
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:found)
    end

    it 'sets job name in session' do
      expect(session[:job][:name]).to eq(job_name)
    end

    it 'sets filename in session' do
      expect(session[:job][:filename]).to eq(file_path.split('/').last)
    end
  end

  context 'with invalid params' do
    let(:file_path) do
      File.join('spec',
                'fixtures', 'files', 'csv', 'empty', 'сAZ-2020-01-08-AuthorityID.csv')
    end

    it 'returns error' do
      http_request
      follow_redirect!
      expect(response.body).to include('The selected file must be named correctly')
    end
  end
end
