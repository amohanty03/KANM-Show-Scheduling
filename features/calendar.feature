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
    And I should see no time slots for the whole day

  Scenario: User wants to export the entire weekly schedule
    Given I visit the calendar index with the day "Tuesday"
    Then I click on the "Export Schedule" button in the calendar page
#    And I should see the downloaded file "Weekly_Schedule.xlsx"

  Scenario: Download button for unassigned RJ list is present
    Given I am on the calendar page
    Then I should see the "Download Unassigned RJ List" link

  Scenario: Download unassigned RJ list as an Excel file
    Given I am on the calendar page
    When I click the "Download Unassigned RJ List" link
    Then I should be able to download an Excel file containing the unassigned RJ list

  Scenario: Upload a file containing data and generate a schedule using it
    Given I upload a CSV file with just two entries
    Then  I should see "RJ_Two_Entries.xlsx"
    When  I check the checkbox for "RJ_Two_Entries.xlsx"
    And   I click the "Generate Schedule" button to generate the schedule
    Then  I should be taken to the calendar page
    Then  I should see 2 filled timeslots

