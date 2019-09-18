# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UploadMailer, type: :mailer do
  let(:user) { new_user(email: email) }
  let(:email) { 'test@example.com' }

  describe '.success_upload' do
    subject(:mail) { described_class.success_upload(user) }

    it { expect(mail.from).to include(ENV['SES_FROM_EMAIL']) }
    it { expect(mail.to).to include(email) }
  end
end
