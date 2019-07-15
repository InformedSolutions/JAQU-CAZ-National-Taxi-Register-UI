# frozen_string_literal: true

require 'rails_helper'

describe UploadController, type: :request do
  describe 'GET #index' do
    subject(:http_request) { get upload_index_path }

    before { sign_in User.new }

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

    before :each do
      sign_in User.new
    end

    context 'with valid params' do
      before do
        allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).and_return(true)
      end

      let(:file_path) { file_fixture('CAZ-2020-01-08-AuthorityID-4321.csv') }

      it 'returns a success response' do
        http_request
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      let(:file_path) do
        File.join('spec',
                  'fixtures',
                  'files',
                  'empty',
                  'сAZ-2020-01-08-AuthorityID-4321.csv')
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

    before { sign_in User.new }

    it 'returns a success response' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end
end
