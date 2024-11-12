Feature: Calendar page

Background: Successful login with a tamu.edu email
    Given I am on the login page
    When  I click the "Login with TAMU Gmail" button as "student@tamu.edu" with name "student" "test"
    And   I select a "student@tamu.edu" email with name "student" "test"
    Then  I check if the email is in the database
    Then  I should be redirected to the welcome page

  Scenario: User views the calendar index for a specific day
    Given I visit the calendar index with the day "Tuesday"
    Then I should see the selected day as "Tuesday"
    And I should see time slots for the whole day

  Scenario: User wants to export the entire weekly schedule
    Given I visit the calendar index with the day "Tuesday"
    Then I click on the "Export Schedule" button in the calendar page
#    And I should see the downloaded file "Weekly_Schedule.xlsx"
