# frozen_string_literal: true

require 'rails_helper'

describe VrnHistory do
  subject(:vehicle) { described_class.new(data) }

  let(:data) do
    {
      'modifyDate' => '2020-03-01',
      'action' => action,
      'licensingAuthorityName' => licensing_authority,
      'plateNumber' => plate_number,
      'licenceStartDate' => '2015-04-09',
      'licenceEndDate' => '2025-03-10',
      'wheelchairAccessible' => wheelchair_accessible
    }
  end

  let(:action) { 'created' }
  let(:licensing_authority) { 'Leeds' }
  let(:plate_number) { 'CU12345' }
  let(:wheelchair_accessible) { true }

  describe '.data_upload_date' do
    it 'returns a proper value' do
      expect(subject.data_upload_date).to eq('01/03/2020')
    end
  end

  describe '.action' do
    context 'when value is `created`' do
      it 'returns a proper value' do
        expect(subject.action).to eq('Added')
      end
    end

    context 'when value is not `created`' do
      let(:action) { 'updated' }

      it 'returns a proper value' do
        expect(subject.action).to eq('Updated')
      end
    end
  end

  describe '.licensing_authority' do
    it 'returns a proper value' do
      expect(subject.licensing_authority).to eq(licensing_authority)
    end
  end

  describe '.plate_number' do
    it 'returns a proper value' do
      expect(subject.plate_number).to eq(plate_number)
    end
  end

  describe '.licence_start_date' do
    it 'returns a proper value' do
      expect(subject.licence_start_date).to eq('09/04/2015')
    end
  end

  describe '.licence_end_date' do
    it 'returns a proper value' do
      expect(subject.licence_end_date).to eq('10/03/2025')
    end
  end

  describe '.wheelchair_accessible' do
    context 'and when `wheelchair_accessible` value is true' do
      it 'returns a `Yes`' do
        expect(subject.wheelchair_accessible).to eq('Yes')
      end
    end

    context 'and when `wheelchair_accessible` value is false' do
      let(:wheelchair_accessible) { false }

      it 'returns a `No`' do
        expect(subject.wheelchair_accessible).to eq('No')
      end
    end
  end
end
