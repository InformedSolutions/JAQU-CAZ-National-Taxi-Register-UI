Feature: Sign in
  In order to read the page
  As a Licensing Authority
  I want to see the upload page

  Scenario: View upload page without cookie
    Given I have no authentication cookie
    When I navigate to a Upload page
    Then I am redirected to the unauthenticated root page
      And I should see 'Sign in'
      And I should see 'Taxi and PHV Data Portal' title
      And I should not see 'Upload' link
      And I should not see 'Data rules' link
      And I should not see 'Search' link
    When I enter valid credentials
    Then I should see 'Taxi and PHV Data Portal'
      And Cookie is created for my session
      And I should see 'Search' link

  Scenario: View upload page with cookie that has not expired
    Given I have authentication cookie that has not expired
    When I navigate to a Upload page
    Then I am redirected to the Upload page
      And I should see 'Taxi and PHV Data Portal'
      And I should see 'Upload' link
      And I should see 'Data rules' link

  Scenario: View upload page with cookie that has expired
    Given I have authentication cookie that has expired
    When I navigate to a Upload page
      And I should not see 'Upload' link
    Then I am redirected to the unauthenticated root page
      And I should see 'Sign in'

  Scenario: Sign in with invalid credentials
    Given I am on the Sign in page
    When I enter invalid credentials
    Then I remain on the current page
      And I should see 'Enter a valid email address and password'

  Scenario: Sign out
    Given I am signed in
    When I request to sign out
    Then I am redirected to the Sign in page
    When I navigate to a Upload page
    Then I am redirected to the unauthenticated root page
      And I should see 'Sign in'

  Scenario: Sign in with invalid email format
    Given I am on the Sign in page
    When I enter invalid email format
    Then I remain on the current page
      And I should see 'Enter your email address in a valid format'
      And I should see 'Enter your password'
