# frozen_string_literal: true

Then('I should be on the login page') do
  expect_path(new_user_session_path)
end

Then('I should be on the Results not found page') do
  expect_path(not_found_vehicles_path)
end

Then('I should see the Service Unavailable page') do
  expect(page).to have_title 'Sorry, the service is unavailable'
end

Then('I should be on the Search page') do
  expect_path(search_vehicles_path)
end

Then('I should be on the Historic Search Results page') do
  expect_path(historic_search_vehicles_path)
end

private

def expect_path(path)
  expect(page).to have_current_path(path)
end
