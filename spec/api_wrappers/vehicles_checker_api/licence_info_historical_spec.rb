# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesCheckerApi.licence_info' do
  subject(:call) { VehiclesCheckerApi.licence_info_historical(vrn: vrn, page: page) }

  let(:vrn) { 'CU57ABC' }
  let(:page) { 2 }

  skip context 'when call returns 200' do
    before do
      vrn_history = read_unparsed_response('licence_info_historical_response.json')
      stub_request(:get, /CU57ABC/).to_return(status: 200, body: vrn_history)
    end

    it 'calls API with proper query data' do
      call
      expect(WebMock).to have_requested(
        :get,
        %r{#{vrn}/licence-info-historical\?pageNumber=#{page - 1}&pageSize=10}
      )
    end

    it 'returns proper fields' do
      expect(call['1'].keys).to contain_exactly(
        'perPage',
        'page',
        'pageCount',
        'totalChangesCount',
        'changes'
      )
    end

    it 'returns proper `changes` fields' do
      expect(call['1']['changes'].first.keys).to contain_exactly(
        'modifyDate',
        'action',
        'licensingAuthorityName',
        'plateNumber',
        'licenceStartDate',
        'licenceEndDate',
        'wheelchairAccessible'
      )
    end

    it 'returns changes list' do
      expect(call['1']['changes']).to be_a(Array)
    end
  end

  skip context 'when call returns 500' do
    before do
      stub_request(:get, /CU57ABC/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises `Error500Exception`' do
      expect { call }.to raise_exception(BaseApi::Error500Exception)
    end
  end

  skip context 'when call returns 400' do
    before do
      stub_request(:get, /CU57ABC/).to_return(
        status: 400,
        body: { 'message' => 'Correlation ID is missing' }.to_json
      )
    end

    it 'raises `Error400Exception`' do
      expect { call }.to raise_exception(BaseApi::Error400Exception)
    end
  end

  skip context 'when call returns 404' do
    before do
      stub_request(:get, /CU57ABC/).to_return(
        status: 404,
        body: { 'message' => "Vehicle with registration number #{vrn} was not found" }.to_json
      )
    end

    it 'raises `Error404Exception`' do
      expect { call }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  skip context 'when call returns 422' do
    before do
      stub_request(:get, /CU57ABC/).to_return(
        status: 422,
        body: { 'message' => "#{vrn} is an invalid registration number" }.to_json
      )
    end

    it 'raises `Error422Exception`' do
      expect { call }.to raise_exception(BaseApi::Error422Exception)
    end
  end
end