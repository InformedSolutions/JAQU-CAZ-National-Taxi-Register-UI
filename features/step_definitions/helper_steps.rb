# frozen_string_literal: true

def sign_in_user
  visit new_user_session_path
  fill_in('user_username', with: 'user@example.com')
  fill_in('user_password', with: '12345678')

  RSpec::Mocks.with_temporary_scope do
    expect_any_instance_of(Aws::CognitoIdentityProvider::Client).to receive(:initiate_auth)
      .and_return(cognito_response)

    click_button 'Continue'
  end
end

def cognito_response
  OpenStruct.new(challenge_parameters: {
                   'USER_ID_FOR_SRP' => 'user@example.com',
                   'userAttributes' => '{"email":""}'
                 })
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Then('I should see {string} title') do |string|
  expect(page).to have_title(string)
end

Then('I press the Continue') do
  click_button 'Continue'
end

Given('I am on the Upload page') do
  sign_in_user
  visit root_path
end

Given('I am on the Sign in page') do
  visit new_user_session_path
end

Then('I should see {string} link') do |string|
  expect(page).to have_link(string)
end

Then('I should not see {string} link') do |string|
  expect(page).not_to have_link(string)
end
