# frozen_string_literal: true

require 'rails_helper'

describe PaginatedVrnHistory do
  subject { described_class.new(data) }

  let(:size) { 51 }
  let(:page) { 3 }
  let(:per_page) { 10 }
  let(:vrn_history) { read_response_file('licence_info_historical_response.json')['1'] }

  let(:data) do
    {
      'changes' => vrn_history,
      'perPage' => per_page,
      'page' => page - 1,
      'pageCount' => (size / per_page.to_f).ceil,
      'totalChangesCount' => size
    }
  end

  describe '.page' do
    it 'returns page value' do
      expect(subject.page).to eq(page)
    end
  end

  describe '.total_pages' do
    it 'returns pageCount value' do
      expect(subject.total_pages).to eq(data['pageCount'])
    end
  end

  describe '.total_vehicles_count' do
    it 'returns size value' do
      expect(subject.total_changes_count).to eq(size)
    end
  end

  describe '.per_page' do
    it 'returns per_page value' do
      expect(subject.per_page).to eq(per_page)
    end
  end

  describe '.range_start' do
    context 'when on the first page' do
      let(:page) { 1 }

      it 'returns 1' do
        expect(subject.range_start).to eq(1)
      end
    end

    context 'when on the other page' do
      it 'returns correct value' do
        expect(subject.range_start).to eq(21)
      end
    end
  end

  describe '.range_end' do
    context 'when on the first page' do
      let(:page) { 1 }

      it 'returns 1' do
        expect(subject.range_end).to eq(per_page)
      end
    end

    context 'when on the other page' do
      it 'returns correct value' do
        expect(subject.range_end).to eq(30)
      end
    end

    context 'when on the last page' do
      let(:page) { 6 }

      it 'returns size' do
        expect(subject.range_end).to eq(size)
      end
    end
  end
end
