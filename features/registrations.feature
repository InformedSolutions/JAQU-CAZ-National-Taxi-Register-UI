Feature: Registrations
  In order to read the page
  As a Licensing Authority
  I want to be able to reset my password

  Scenario: View password updated page
    Given I am on the Sign in page
    When I press "Forgot your password?" link
    Then I should see "Enter you email address to reset your password"
      And I press "Reset password" button
    Then I should see "You must enter your email address"
      And I enter email input with "user"
      And I press "Reset password" button
    Then I should see "You must enter your email in valid format"
      And I enter email input with "user@example.com"
      And I press "Reset password" button
    Then I should see "Update your password"
      And I press "Reset password" button
    Then I should see "You must enter your confirmation code"
      And I enter confirmation code input with "1234"
      And I press "Reset password" button
    Then I should see "You must enter your password"
      And I enter password input with "password"
      And I press "Reset password" button
    Then I should see "You must confirm your password"
      And I enter password input with "password"
      And I enter password confirmation input with "pass"
      And I press "Reset password" button
    Then I should see "Your password doesn't match password confirmation"
      And I enter password input with "password"
      And I enter password confirmation input with "password"
      And I press "Reset password" button
    Then I should see "We have successfully updated your password"
