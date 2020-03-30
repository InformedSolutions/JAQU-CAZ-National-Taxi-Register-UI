Feature: Search a VRN
  In order to read the page
  As a user
  I want to search a vrn

  Scenario: Search a VRN
    Given I am on the Search VRN page
    When I press 'Continue' button
    Then I should see 'Enter the number plate of the vehicle'
      And I should see 'Choose a search type'
    When I enter a vrn
      And I press 'Continue' button
    Then I should see "You searched for CU57ABC"

  Scenario: Search VRN in an invalid format
    Given I am on the Search VRN page
      And I enter an invalid vrn format
      And I press 'Continue' button
    Then I should see 'Enter the number plate of the vehicle in a valid format'

  Scenario: VRN not found
    Given I am on the Search VRN page
      And I enter a vrn which not exists in database
      And I press 'Continue' button
    Then I should be on the Results not found page

  Scenario: Server is unavailable
    Given I am on the Search VRN page
      And I enter a vrn when server is unavailable
      And I press 'Continue' button
    Then I should see the Service Unavailable page

  Scenario: Search a VRN for historical results
    Given I am on the Search VRN page
    When I enter a vrn and choose Search for historical results
      And I press 'Continue' button
    Then I should see 'Start date must include a day, month and year'
      And I should see 'End date must include a day, month and year'
    Then I enter a vrn and invalid date format
      And I press 'Continue' button
    Then I should see 'Enter a real start date'
    When I enter a vrn and enter start date in the future
      And I press 'Continue' button
    Then I should see 'Start date must be earlier than end date'
