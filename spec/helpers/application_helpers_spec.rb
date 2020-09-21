# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  describe '.service_email' do
    subject { helper.service_email }

    it 'returns a proper value' do
      expect(subject).to eq('TaxiandPHVCentralised.Database@defra.gov.uk')
    end
  end
end
