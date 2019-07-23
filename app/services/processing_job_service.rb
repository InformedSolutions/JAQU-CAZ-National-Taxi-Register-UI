# frozen_string_literal: true

class ProcessingJobService < BaseService
  CSV_FAILURE_FORMAT_STATUSES = %w[
    FINISHED_FAILURE_EACH_ROW_INVALID FINISHED_OK_SOME_VALIDATION_ERRORS
  ].freeze
  attr_reader :job_uuid, :success, :errors

  def initialize(job_uuid:)
    @job_uuid = job_uuid
    @success = false
    @errors = []
  end

  def call
    if job_status == 'RUNNING'
    elsif job_status == 'FINISHED_OK_NO_ERRORS'
      @success = true
    else
      @errors = job_errors.join(', ')
    end
    self
  end

  def success?
    success && errors.empty?
  end

  def in_progress?
    !success && errors.empty?
  end

  def invalid_csv?
    CSV_FAILURE_FORMAT_STATUSES.include?(job_status)
  end

  private

  def api_response
    @api_response ||= Connection::RegisterCheckerApi.check_job_status(job_uuid)
  end

  def job_status
    api_response['registerCsvFromS3JobStatus']
  end

  def job_errors
    api_response['errors']
  end
end
