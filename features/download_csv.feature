# features/download_csv.feature

Feature: CSV File Download

  Background: Successful login with a tamu.edu email
    Given I am on the login page
    When  I click the "Login with TAMU Gmail" button as "student@tamu.edu" with name "student" "test"
    And   I select a "student@tamu.edu" email with name "student" "test"
    Then  I check if the email is in the database
    Then  I should be redirected to the welcome page

  Scenario: Downloading a selected CSV file
    Given there are some CSV files in the test uploads directory
    And I select the file "test1.csv"
    When I click the download button for "test1.csv"
    Then the file "archived_files.zip" should be saved in "tmp/test_downloads"

  Scenario: Not downloading when no files are selected
    Given there are some CSV files in the test uploads directory
    And there are no files in the test downloads directory
    When I click the download button for no files
    Then the file "archived_files.zip" should not be saved in "tmp/test_downloads"