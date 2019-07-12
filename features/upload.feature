Feature: Upload
  In order to read the page
  As a Licensing Authority
  I want to upload a CSV file

  Scenario: Upload without file
    Given I am on the Upload page
    When I press "Upload" button
    Then I should see "Select a CSV"

  Scenario: Upload a csv file whose name is compliant with the naming rules
    Given I am on the Upload page
    When I upload a valid csv file
    Then I should see "Upload successful"

  Scenario: Upload a csv file whose name is not compliant with the naming rules
    Given I am on the Upload page
    When I upload a csv file whose name format is invalid #1
    Then I should see "The selected file must be named correctly"
    When I upload a csv file whose name format is invalid #2
    Then I should see "The selected file must be named correctly"
    When I upload a csv file whose name format is invalid #3
    Then I should see "The selected file must be named correctly"
    When I upload a csv file whose name format is invalid #4
    Then I should see "The selected file must be named correctly"
    When I upload a csv file whose name format is invalid #5
    Then I should see "The selected file must be named correctly"
    When I upload a csv file whose name format is invalid #6
    Then I should see "The selected file must be named correctly"

  Scenario: Upload a csv file format that is not .csv or .CSV
    Given I am on the Upload page
    When I upload a csv file whose format that is not .csv or .CSV
    Then I should see "The selected file must be a CSV"

  Scenario: Upload a valid csv file during error is encountered writing to S3
    Given I am on the Upload page
    When I upload a csv file during error on S3
    Then I should see "The selected file could not be uploaded – try again"
