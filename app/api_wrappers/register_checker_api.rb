# frozen_string_literal: true

class RegisterCheckerApi < BaseApi
  base_uri ENV['TAXI_PHV_REGISTER_API_URL']

  class << self
    def register_job(file_name, correlation_id)
      log_call("Registering job with file name: #{file_name}")
      params = {
        "filename": file_name,
        "s3Bucket": bucket_name
      }.to_json

      response = request(:post, '/v1/scheme-management/register-csv-from-s3/jobs',
                         body: params, headers: custom_headers(correlation_id))
      response['jobName']
    end

    def job_status(job_uuid, correlation_id)
      log_call("Getting job status with job uuid: #{job_uuid}")
      response = request(:get, "/v1/scheme-management/register-csv-from-s3/jobs/#{job_uuid}",
                         headers: custom_headers(correlation_id))
      response['status']
    end

    def job_errors(job_uuid, correlation_id)
      log_call("Getting job errors with job uuid: #{job_uuid}")
      response = request(:get, "/v1/scheme-management/register-csv-from-s3/jobs/#{job_uuid}",
                         headers: custom_headers(correlation_id))
      return nil unless response['status'] == 'FAILURE'

      response['errors']
    end

    private

    def log_call(msg)
      Rails.logger.info "[RegisterCheckerApi] #{msg}"
    end

    def bucket_name
      ENV['S3_AWS_BUCKET']
    end

    def custom_headers(correlation_id)
      {
        'Content-Type' => 'application/json',
        'X-Correlation-ID' => correlation_id
      }
    end
  end
end
