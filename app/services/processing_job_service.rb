# frozen_string_literal: true

class ProcessingJobService < BaseService
  attr_reader :job_uuid

  def initialize(job_uuid:)
    @job_uuid = job_uuid
  end

  def call
    Connection::RegisterCheckerApi.check_job_status(job_uuid)
    # TO DO: redirect_to depends on response
  end
end
