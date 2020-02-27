Feature: Search a VRN
  In order to read the page
  As a user
  I want to search a vrn

  Scenario: Search a VRN
    Given I am on the Search VRN page
    When I press 'Search' button
    Then I should see 'Enter the registration number of the vehicle'
    When I enter a vrn
      And I press 'Search' button
    Then I should see "You searched for CU57ABC"

  Scenario: Search VRN in an invalid format
    Given I am on the Search VRN page
      And I enter an invalid vrn format
      And I press 'Search' button
    Then I should see 'Enter the number plate of the vehicle in a valid format'

  Scenario: VRN not found
    Given I am on the Search VRN page
      And I enter a vrn which not exists in database
      And I press 'Search' button
    Then I should be on the Results not found page

  Scenario: Server is unavailable
    Given I am on the Search VRN page
      And I enter a vrn when server is unavailable
      And I press 'Search' button
    Then I should see the Service Unavailable page
