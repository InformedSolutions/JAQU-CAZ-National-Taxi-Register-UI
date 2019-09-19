# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ses::SendSuccessEmail do
  subject(:service_call) { described_class.call(user: user, job_data: job_data) }

  let(:user) { new_user(email: email) }
  let(:email) { 'user@example.com' }
  let(:job_data) { { filename: filename, submission_time: time } }
  let(:filename) { 'CAZ-2020-01-08-AuthorityID-1.csv' }
  let(:time) { Time.current.strftime(Rails.configuration.x.time_format) }

  context 'with valid params' do
    before do
      mailer = OpenStruct.new(deliver: true)
      allow(UploadMailer).to receive(:success_upload).and_return(mailer)
    end

    it 'returns true' do
      expect(service_call).to be_truthy
    end

    it 'sends an email with proper params' do
      expect(UploadMailer).to receive(:success_upload).with(user, filename, time)
      service_call
    end
  end

  context 'when sending emails fails' do
    before do
      allow(UploadMailer).to receive(:success_upload).and_raise(
        Aws::SES::Errors::MessageRejected.new('', 'error')
      )
    end

    it 'returns false' do
      expect(service_call).to be_falsey
    end
  end
end
