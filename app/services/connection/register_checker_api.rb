# frozen_string_literal: true

module Connection
  class RegisterCheckerApi < BaseApi
    base_uri ENV['TAXI_PHV_REGISTER_API_URL']

    headers(
      'Content-Type' => 'application/json',
      'X-Correlation-ID' => SecureRandom.uuid
    )

    class << self
      def register_job(file_name)
        params = {
          "filename": file_name,
          "s3Bucket": bucket_name
        }.to_json

        response = request(:post, '/register-csv-from-s3/jobs', body: params)
        response['registerCsvFromS3JobId']
      end

      def check_job_status(job_uuid)
        response = request(:get, "/register-csv-from-s3/jobs/#{job_uuid}")
        response['registerCsvFromS3JobStatus']
      end

      private

      def bucket_name
        ENV['S3_AWS_BUCKET']
      end
    end
  end
end
