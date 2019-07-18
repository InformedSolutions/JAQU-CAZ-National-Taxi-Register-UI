# frozen_string_literal: true

Then('I enter email input with {string}') do |string|
  fill_in('email', with: string)
end

Then('I enter confirmation code input with {string}') do |string|
  fill_in('confirmation_code', with: string)
end

Then('I enter password input with {string}') do |string|
  fill_in('password', with: string)
end

Then('I enter password confirmation input with {string}') do |string|
  fill_in('password_confirmation', with: string)
end
