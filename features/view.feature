Feature: View page

Background: Successful login with a tamu.edu email
    Given I am on the login page
    When  I click the "Login with TAMU Gmail" button as "student@tamu.edu" with name "student" "test"
    And   I select a "student@tamu.edu" email with name "student" "test"
    Then  I check if the email is in the database
    Then  I should be redirected to the welcome page

  Scenario: User sees the application title
    Then I should see "KANM Radio Show Scheduler"

  Scenario: No files are present in the test uploads directory
    Given there are no CSV files in the test uploads directory
    When I visit the welcome page
    Then I should see "No files are present"

  Scenario: CSV files are present in the test uploads directory
    Given there are some CSV files in the test uploads directory
    When I visit the welcome page
    Then I should see the uploaded files listed

  Scenario: Select files and verify the tick mark appears
      Given there are some CSV files in the test uploads directory
      And I select the file "test1.csv"
      Then the file "test1.csv" should be marked as selected
