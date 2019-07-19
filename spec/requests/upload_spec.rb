# frozen_string_literal: true

require 'rails_helper'

describe UploadController, type: :request do
  let(:file_path) do
    File.join(
      'spec',
      'fixtures', 'files', 'csv', 'CAZ-2020-01-08-AuthorityID-4321.csv'
    )
  end

  before :each do
    sign_in User.new
  end

  describe 'GET #index' do
    subject(:http_request) { get upload_index_path }

    it 'returns a success response' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #import' do
    subject(:http_request) do
      post import_upload_index_path, params: { file: csv_file }
    end

    let(:csv_file) { fixture_file_upload(file_path) }

    context 'with valid params' do
      before do
        allow(CsvUploadService).to receive(:call).and_return(true)
        mock_register_job
      end

      it 'returns a success response' do
        http_request
        expect(response).to have_http_status(:found)
      end
    end

    context 'with invalid params' do
      let(:file_path) do
        File.join('spec',
                  'fixtures', 'files', 'csv', 'empty', 'сAZ-2020-01-08-AuthorityID-4321.csv')
      end

      it 'returns error' do
        http_request
        follow_redirect!
        expect(response.body).to include 'The selected file must be named correctly'
      end
    end
  end

  describe 'GET #data_rules' do
    subject(:http_request) { get data_rules_path }

    it 'returns a success response' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #processing' do
    subject(:upload_file_request) do
      post import_upload_index_path, params: { file: csv_file }
    end

    let(:csv_file) { fixture_file_upload(file_path) }

    before do
      allow(CsvUploadService).to receive(:call).and_return(true)
      mock_register_job
      mock_finished_job
      # we call upload endpoint and will be redirected to processing page
      upload_file_request
      follow_redirect!
    end

    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end
  end
end
