Feature: delete file

Background: Successful login with a tamu.edu email
    Given I am on the login page
    When  I click the "Login with TAMU Gmail" button as "student@tamu.edu" with name "student" "test"
    And   I select a "student@tamu.edu" email with name "student" "test"
    Then  I check if the email is in the database
    Then  I should be redirected to the welcome page


Scenario: one files is selected
    Given I visit the welcome page
        Given there are CSV files in the test uploads directory
        When I select the file "test1.xlsx"
        And I click on the 'Delete Selected Files' button
        Then the file "test1.csv" should not be present in the uploads directory
        

Scenario: two files is selected
    Given I visit the welcome page
        Given there are CSV files in the test uploads directory
        When I select the file "test2.xlsx"
        And I select the file "test3.xlsx"
        And I click on the 'Delete Selected Files' button
        Then the file "test2.csv" should not be present in the uploads directory
        And the file "test3.csv" should not be present in the uploads directory

Scenario: no files selected
    Given I visit the welcome page
        Given there are CSV files in the test uploads directory
        When I click on the 'Delete Selected Files' button
        Then no files should be deleted from the uploads directory