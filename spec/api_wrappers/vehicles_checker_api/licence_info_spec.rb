# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesCheckerApi.licence_info' do
  subject(:call) { VehiclesCheckerApi.licence_info(vrn) }

  let(:vrn) { 'CU57ABC' }

  context 'when call returns 200' do
    before do
      vrn_details = file_fixture('responses/licence_info_response.json').read
      stub_request(:get, /CU57ABC/).to_return(status: 200, body: vrn_details)
    end

    it 'returns proper fields' do
      expect(call.keys).to contain_exactly(
        'active',
        'wheelchairAccessible',
        'description',
        'licensingAuthoritiesNames'
      )
    end
  end

  context 'when call returns 500' do
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

  context 'when call returns 400' do
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

  context 'when call returns 404' do
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

  context 'when call returns 422' do
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
