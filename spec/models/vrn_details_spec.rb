# frozen_string_literal: true

require 'rails_helper'

describe VrnDetails do
  subject { described_class.new(vrn) }

  let(:vrn) { 'CU57ABC' }

  let(:response) do
    {
      active: active,
      description: description,
      wheelchairAccessible: wheelchair_accessible,
      licensingAuthoritiesNames: %w[Birmingham Leeds]
    }.stringify_keys
  end
  let(:active) { true }
  let(:description) { 'taxi' }
  let(:wheelchair_accessible) { true }

  before do
    allow(VehiclesCheckerApi).to receive(:licence_info).and_return(response)
  end

  describe '.registration_number' do
    it 'returns a proper registration number' do
      expect(subject.registration_number).to eq(vrn)
    end
  end

  describe '.taxi_private_hire_vehicle' do
    context 'when active value is true' do
      context 'when description is phv' do
        let(:description) { 'phv' }

        it 'returns `PHV`' do
          expect(subject.taxi_private_hire_vehicle).to eq('PHV')
        end
      end

      context 'when description is taxi' do
        let(:description) { 'taxi' }

        it 'returns `Taxi`' do
          expect(subject.taxi_private_hire_vehicle).to eq('Taxi')
        end
      end
    end

    context 'when active value is false' do
      let(:active) { false }

      it 'returns a `No`' do
        expect(subject.taxi_private_hire_vehicle).to eq('No')
      end
    end
  end

  describe '.wheelchair_accessible' do
    context 'when `active` value is true' do
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

    describe 'when `active` value is false' do
      let(:active) { false }

      context 'and when `wheelchair_accessible` value is true' do
        it 'returns a `-`' do
          expect(subject.wheelchair_accessible).to eq('-')
        end
      end

      context 'and when `wheelchair_accessible` value is false' do
        let(:wheelchair_accessible) { false }

        it 'returns a `-`' do
          expect(subject.wheelchair_accessible).to eq('-')
        end
      end
    end
  end

  describe '.licensing_authorities' do
    context 'when `active` value is true' do
      it 'returns a string of licensing authorities ' do
        expect(subject.licensing_authorities).to eq('Birmingham, Leeds')
      end
    end

    describe 'when `active` value is false' do
      let(:active) { false }

      it 'returns a `-`' do
        expect(subject.licensing_authorities).to eq('-')
      end
    end
  end
end
