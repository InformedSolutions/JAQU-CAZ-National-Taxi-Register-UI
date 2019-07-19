# frozen_string_literal: true

module MockHelper
  def mock_register_job
    job_uuid = {
      "registerCsvFromS3JobId": 'ae67c64a-1d9e-459b-bde0-756eb73f36fe'
    }.to_json

    stub_request(:post, %r{register-csv-from-s3/jobs}).to_return(status: 200, body: job_uuid)
  end

  def mock_finished_job
    status_finished = {
      "registerCsvFromS3JobStatus": 'FINISHED_OK_NO_ERRORS'
    }.to_json

    stub_request(:get,
                 %r{register-csv-from-s3/jobs/ae67c64a-1d9e-459b-bde0-756eb73f36fe}).to_return(
                   status: 200, body: status_finished
                 )
  end
end
