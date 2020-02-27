# frozen_string_literal: true

Given('I am on the Search VRN page') do
  sign_in_user
  visit search_vehicles_path
end

When('I enter a vrn') do
  response = read_response_file('licence_info_response.json')
  allow(api).to receive(:licence_info).with(vrn).and_return(response)
  fill_vrn
end

When('I enter an invalid vrn format') do
  fill_vrn('****&&&%%%%')
end

When('I enter a vrn when server is unavailable') do
  allow(api).to receive(:licence_info).with(vrn).and_raise(Errno::ECONNREFUSED)
  fill_vrn
end

When('I enter a vrn which not exists in database') do
  service = BaseApi::Error404Exception
  allow(api).to receive(:licence_info).with(vrn).and_raise(
    service.new(404, 'VRN number was not found', {})
  )
  fill_vrn
end

private

def fill_vrn(vrn_value = vrn)
  fill_in('vrn', with: vrn_value)
end

def vrn
  'CU57ABC'
end

def api
  VehiclesCheckerApi
end
