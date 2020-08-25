# frozen_string_literal: true

Given('I am on the Search VRN page') do
  sign_in_user
  visit search_vehicles_path
end

When('I enter a vrn {string}') do |vrn_value|
  response = read_response_file('licence_info_response.json')
  allow(api).to receive(:licence_info).with(vrn).and_return(response)
  fill_vrn(vrn_value)
  choose('Quick search')
end

When('I enter a vrn and choose Search for historical results') do
  fill_vrn
  choose('Detailed search')
end

When('I enter a vrn and valid dates format') do
  mock_vrn_history
  fill_vrn
  fill_dates
  choose('Detailed search')
end

When('I enter a vrn without history and valid dates format') do
  mock_vrn_history(page: 1, total_changes_count_zero: true, changes_empty: true)
  fill_vrn
  fill_dates
  choose('Detailed search')
end

When('I enter a vrn and invalid dates format') do
  fill_vrn
  choose('Detailed search')
  fill_in('search_start_date_day', with: 44)
  fill_in('search_start_date_month', with: 44)
  fill_in('search_start_date_year', with: 4444)
  fill_in('search_end_date_day', with: 13)
  fill_in('search_end_date_month', with: 13)
  fill_in('search_end_date_year', with: 2013)
end

When('I enter a vrn and start date earlier than end date') do
  fill_vrn
  choose('Detailed search')
  fill_in('search_start_date_day', with: Time.zone.tomorrow.day.to_s)
  fill_in('search_start_date_month', with: Time.zone.tomorrow.month.to_s)
  fill_in('search_start_date_year', with: Time.zone.tomorrow.year.to_s)
  fill_in('search_end_date_day', with: Time.zone.now.day.to_s)
  fill_in('search_end_date_month', with: Time.zone.now.month.to_s)
  fill_in('search_end_date_year', with: Time.zone.now.year.to_s)
end

When('I enter a vrn and negative start date') do
  fill_vrn
  choose('Detailed search')
  fill_negative_start_date
end

When('I enter a vrn and negative end date') do
  fill_vrn
  choose('Detailed search')
  fill_negative_end_date
end

When('I enter an invalid vrn format') do
  fill_vrn('****&&&%%%%')
end

When('I enter a vrn when server is unavailable') do
  allow(api).to receive(:licence_info).with(vrn).and_raise(Errno::ECONNREFUSED)
  fill_vrn
  choose('Quick search')
end

When('I enter a vrn which not exists in database') do
  service = BaseApi::Error404Exception
  allow(api).to receive(:licence_info).with(vrn).and_raise(
    service.new(404, 'VRN number was not found', {})
  )
  fill_vrn
  choose('Quick search')
end

Given('I am on the Historical results page') do
  sign_in_user
  add_vrn_to_session
  mock_vrn_history
  visit historic_search_vehicles_path
end

Then('I should see active {string} pagination button') do |text|
  button = page.find("#pagination-button-#{text}")
  expect(button[:class]).to include('moj-pagination__item--active')
end

Then('I should see inactive {string} pagination button') do |text|
  button = page.find("#pagination-button-#{text}")
  expect(button[:class]).not_to include('moj-pagination__item--active')
end

Then('I should not see {string} pagination button') do |text|
  expect(page).not_to have_selector("#pagination-button-#{text}")
end

When('I press {int} pagination button') do |selected_page|
  mock_vrn_history(page: selected_page)
  page.find("#pagination-button-#{selected_page}").first('a').click
end

And('I should be on the Search results') do
  expect(page).to have_current_path(historic_search_vehicles_url)
end

And('I should be on the Search results page number {int}') do |page_number|
  expect(page).to have_current_path("#{historic_search_vehicles_url}?page=#{page_number}")
end

And('I should be on the Search results page number {int} when using back button') do |page_number|
  expect(page).to have_current_path("#{historic_search_vehicles_url}?page=#{page_number}?back=true")
end

And('I go the Search vehicles results page') do
  visit historic_search_vehicles_path
end

private

def fill_vrn(vrn_value = vrn)
  fill_in('vrn', with: vrn_value)
  choose('Detailed search')
end

def fill_dates
  fill_in('search_start_date_day', with: 10)
  fill_in('search_start_date_month', with: 3)
  fill_in('search_start_date_year', with: 2020)
  fill_in('search_end_date_day', with: 14)
  fill_in('search_end_date_month', with: 3)
  fill_in('search_end_date_year', with: 2020)
end

def fill_negative_start_date
  fill_in('search_start_date_day', with: -10)
  fill_in('search_start_date_month', with: 3)
  fill_in('search_start_date_year', with: 2020)
  fill_in('search_end_date_day', with: 14)
  fill_in('search_end_date_month', with: 3)
  fill_in('search_end_date_year', with: 2020)
end

def fill_negative_end_date
  fill_in('search_start_date_day', with: 10)
  fill_in('search_start_date_month', with: 3)
  fill_in('search_start_date_year', with: 2020)
  fill_in('search_end_date_day', with: -14)
  fill_in('search_end_date_month', with: 3)
  fill_in('search_end_date_year', with: 2020)
end

def vrn
  'CU57ABC'
end

def api
  VehiclesCheckerApi
end

def mock_vrn_history(page: 1, total_changes_count_zero: false, changes_empty: false)
  allow(HistoricalVrnDetails).to receive(:new).and_return(
    create_history(page, total_changes_count_zero, changes_empty)
  )
end

def create_history(page, total_changes_count_zero, changes_empty)
  instance_double(HistoricalVrnDetails,
                  pagination: paginated_history(page),
                  total_changes_count_zero?: total_changes_count_zero,
                  changes_empty?: changes_empty)
end

def mocked_changes
  vehicles_data = read_response_file('licence_info_historical_response.json')['1']['changes']
  vehicles_data.map { |data| VrnHistory.new(data) }
end

def paginated_history(page = 1)
  instance_double(
    PaginatedVrnHistory,
    vrn_changes_list: mocked_changes,
    page: page,
    total_pages: 5,
    range_start: 1,
    range_end: 10,
    total_changes_count: 42
  )
end
