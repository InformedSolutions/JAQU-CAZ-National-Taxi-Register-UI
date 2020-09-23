# frozen_string_literal: true

require 'rails_helper'

describe HistoricalVrnDetails do
  subject { described_class.new(vrn, page, start_date, end_date) }

  let(:vrn) { 'CU57ABC' }
  let(:page) { 1 }
  let(:start_date) { '2010-01-01' }
  let(:end_date) { '2020-03-24' }
  let(:vrn_history) { read_response_file('licence_info_historical_response.json')[page.to_s] }

  before do
    allow(VehiclesCheckerApi)
      .to receive(:licence_info_historical)
      .and_return(vrn_history)
  end

  describe '.pagination' do
    let(:changes) { subject.pagination }

    it 'calls `VehiclesCheckerApi.licence_info_historical` with proper params' do
      expect(VehiclesCheckerApi)
        .to receive(:licence_info_historical)
        .with(vrn: vrn, page: page, start_date: start_date, end_date: end_date)
      changes
    end

    it 'returns a PaginatedVrnHistory' do
      expect(changes).to be_a(PaginatedVrnHistory)
    end

    describe '.vehicle_list' do
      it 'returns an list of changes' do
        expect(changes.vrn_changes_list).to all(be_a(VrnHistory))
      end
    end

    describe '.page' do
      it 'returns the page value increased by 1' do
        expect(changes.page).to eq(vrn_history['page'] + 1)
      end
    end

    describe '.total_pages' do
      it 'returns the total pages count value' do
        expect(changes.total_pages).to eq(vrn_history['pageCount'])
      end
    end
  end

  describe '.changes_empty?' do
    it 'calls `AccountsApi.licence_info_historical` with proper params' do
      expect(VehiclesCheckerApi)
        .to receive(:licence_info_historical)
        .with(vrn: vrn, page: 1, start_date: start_date, end_date: end_date)
      subject.changes_empty?
    end

    context 'when some changes returned' do
      it 'returns false' do
        expect(subject.changes_empty?).to be_falsey
      end
    end

    context 'when no changes returned' do
      let(:vrn_history) { { 'changes' => [] } }

      it 'returns true' do
        expect(subject.changes_empty?).to be_truthy
      end
    end
  end

  describe '.total_changes_count_zero??' do
    it 'calls `AccountsApi.licence_info_historical` with proper params' do
      expect(VehiclesCheckerApi)
        .to receive(:licence_info_historical)
        .with(vrn: vrn, page: 1, start_date: start_date, end_date: end_date)
      subject.total_changes_count_zero?
    end

    context 'when count not zero' do
      it 'returns false' do
        expect(subject.total_changes_count_zero?).to be_falsey
      end
    end

    context 'when count is zero' do
      let(:vrn_history) { { 'totalChangesCount' => 0 } }

      it 'returns true' do
        expect(subject.total_changes_count_zero?).to be_truthy
      end
    end
  end
end
