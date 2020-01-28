Feature: Static Pages
  In order to read the page
  As a Licensing Authority
  I want to see the static pages

  Scenario: User sees accessibility statement page
    Given I am on the Sign in page
    When I press Accessibility link
    Then I should see "Accessibility statement for Centralised Taxi and Private Hire Vehicle Database"
    And I should see "Reporting accessibility problems with this website"

  Scenario: User sees cookies page
    Given I am on the Sign in page
    When I press Cookies link
    Then I should see "Cookies"
      And I should see "A cookie is a small piece of data"

  Scenario: User sees privacy notice page
    Given I am on the Sign in page
    When I press Privacy link
    Then I should see "Privacy Notice"
    And I should see "Who is collecting the data?"
