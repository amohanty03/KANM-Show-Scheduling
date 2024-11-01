Feature: Welcome Page
  Background: Successful login with a tamu.edu email
    Given I am on the login page
    When  I click the "Login with TAMU Gmail" button as "student@tamu.edu" with name "student" "test"
    And   I select a "student@tamu.edu" email with name "student" "test"
    Then  I check if the email is in the database
    Then  I should be redirected to the welcome page

    Scenario: User handles file generation with a valid file
      Given I visit the welcome page
      And I upload a valid CSV file
      And I select the file "Test_Sample_v2.xlsx"
      When I choose to "Generate Schedule"
      Then I should be redirected to the calendar page

    Scenario: User tries to handle file generation with no files selected
      Given I visit the welcome page
      Given there are some CSV files in the test uploads directory
      When I choose to "Generate Schedule" without selecting a file
      Then I should see an alert "Please select exactly one file to parse."