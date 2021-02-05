# frozen_string_literal: true

def fill_new_password_form
  fill_in('user_password_confirmation', with: 'password')
  fill_in('user_password', with: 'password')
  click_button 'Continue'
end

And('I am a newly created user') do
  allow(Cognito::AuthUser).to receive(:call).and_return(challenged_cognito_user)
end

And('I enter valid credentials and press the Continue') do
  basic_sign_in
end

Then('I am transferred to the Force Change password page') do
  expect(page).to have_current_path(new_password_path, ignore_query: true)
end

Given('I am on a Force Change password page') do
  sign_in_challenged_user
  visit new_password_path
end

And('I enter password that does not comply with Cognito setup password policy') do
  service = Cognito::RespondToAuthChallenge
  allow(service).to receive(:call).and_raise(
    NewPasswordException.new(service.send(:password_complexity_error))
  )
  fill_new_password_form
end

And('I can retry') do
  fill_new_password_form
end

And('I enter password that is compliant with Cognito setup password policy') do
  allow(Cognito::RespondToAuthChallenge).to receive(:call).and_return(unchallenged_cognito_user)
  fill_new_password_form
end

Then('I am taken to Password set successfully page') do
  expect(page).to have_current_path(success_passwords_path, ignore_query: true)
end
