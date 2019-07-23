# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessingJobService do
  subject(:service_call) { described_class.call(job_uuid: job_uuid) }

  let(:job_uuid) { 'ae67c64a-1d9e-459b-bde0-756eb73f36fe' }

  describe '#call' do
    context 'with valid params' do
      context 'in process status' do
        before do
          mock_job_status(status: 'RUNNING')
        end

        it 'returns true' do
          expect(service_call.in_progress?).to be true
        end
      end

      context 'successful status' do
        before do
          mock_job_status(status: 'FINISHED_OK_NO_ERRORS')
        end

        it 'returns true' do
          expect(service_call.success?).to be true
        end
      end

      context 'invalid csv status' do
        before do
          error_msg = 'Licence start date cannot be after end date in row 2'
          mock_job_status(status: 'FINISHED_OK_SOME_VALIDATION_ERRORS', errors: [error_msg])
        end

        it 'returns true' do
          expect(service_call.invalid_csv?).to be true
        end
      end

      context 'failure startup status' do
        before do
          error_msg = 'Uploaded file is too large'
          mock_job_status(status: 'STARTUP_FAILURE_TOO_LARGE_FILE', errors: [error_msg])
        end

        it 'returns true' do
          expect(service_call.success? && service_call.in_progress? && service_call.invalid_csv?)
            .to_not be true
        end
      end
    end
  end

  def mock_job_status(status: '', errors: [])
    response = {
      "registerCsvFromS3JobStatus": status,
      "errors": errors
    }.to_json

    stub_request(:get,
                 %r{register-csv-from-s3/jobs/ae67c64a-1d9e-459b-bde0-756eb73f36fe}).to_return(
                   status: 200, body: response
                 )
  end
end
