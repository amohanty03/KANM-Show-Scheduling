# features/upload_csv.feature

Feature: CSV File Upload

  Background: Successful login with a tamu.edu email
    Given I am on the login page
    When  I click the "Login with TAMU Gmail" button as "student@tamu.edu" with name "student" "test"
    And   I select a "student@tamu.edu" email with name "student" "test"
    Then  I check if the email is in the database
    Then  I should be redirected to the welcome page

    Scenario: Uploading a valid CSV file
      Given I am on the login page
      When I upload a valid CSV file
      Then I should see "test1.csv"
      And the file "test1.csv" should be saved in "tmp/test_uploads"