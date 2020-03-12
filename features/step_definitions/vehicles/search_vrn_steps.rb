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

When('I enter a vrn and choose Search for historical results') do
  fill_vrn
  choose('Search for historical results')
end

When('I enter a vrn and invalid date format') do
  fill_vrn
  choose('Search for historical results')
  fill_in('search_start_date_day', with: 44)
  fill_in('search_start_date_month', with: 44)
  fill_in('search_start_date_year', with: 4444)
  fill_in('search_end_date_day', with: 13)
  fill_in('search_end_date_month', with: 13)
  fill_in('search_end_date_year', with: 2013)
end

When('I enter a vrn and enter start date in the future') do
  fill_vrn
  choose('Search for historical results')
  fill_in('search_start_date_day', with: Time.zone.tomorrow.day.to_s)
  fill_in('search_start_date_month', with: Time.zone.tomorrow.month.to_s)
  fill_in('search_start_date_year', with: Time.zone.tomorrow.year.to_s)
  fill_in('search_end_date_day', with: Time.zone.now.day.to_s)
  fill_in('search_end_date_month', with: Time.zone.now.month.to_s)
  fill_in('search_end_date_year', with: Time.zone.now.year.to_s)
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
  choose('Search for current information')
end

def vrn
  'CU57ABC'
end

def api
  VehiclesCheckerApi
end
