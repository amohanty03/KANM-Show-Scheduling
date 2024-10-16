Feature: Superuser Admin Management
    As a superuser
    I want to manage admin accounts
    So that I can maintain control over user access

    Scenario: Successful login with a tamu.edu email
        Given I am on the login page
        When  I click the "Login with TAMU Gmail" button as "superuser@tamu.edu" with name "Super" "User"
        And   I select a "superuser@tamu.edu" email with name "Super" "User"
        Then  I should be redirected to the welcome page

    Scenario: Navigate to Admin List page
        Given I am on the welcome page
        When  I should click the dropdown "Manage Admins" button
        Then  I should see the admin list page

    Scenario: View the details of an admin
        Given I am on the Admin list page
        When  I click the first "Show this admin" link
        Then  I should see the admin's details with email "superuser@tamu.edu"

    Scenario: Edit the details of an admin with valid and invalid details
        Given I am on the Admin list page
        When  I click the first "Show this admin" link
        Then  I should see the admin's details with email "superuser@tamu.edu"
        When  I click the "Edit this Admin" link
        Then  I am on the Edit Admin Page for admin with email "superuser@tamu.edu"
        When  I fill in the "Uin" field with "987654321"
        And   I submit the form with button "Update Admin"
        Then  I should see the admin's details with email "superuser@tamu.edu"
        And   I should see the updated Uin "987654321"
        When  I click the "Edit this Admin" link
        And   I fill in the "Email" field INCORRECTLY with "superuser@tamu"
        And   I submit the form with button "Update Admin"
        Then  I should see an error has occurred while "updating" admin

    Scenario: Add a new admin with valid and invalid details
        Given I am on the Admin list page
        When  I click the "New admin" link
        Then  I fill in the "Email" field with "newuser@tamu.edu"
        And   I submit the form with button "Create Admin"
        Then  I should see the admin's details with email "newuser@tamu.edu"
        When  I click the "Back to Admin List" link
        When  I click the "New admin" link
        And   I fill in the "Email" field INCORRECTLY with "superuser@tamu"
        And   I submit the form with button "Create Admin"
        Then  I should see an error has occurred while "creating" admin

    Scenario: Add a new admin and then delete that admin
        Given I am on the Admin list page
        When  I click the "New admin" link
        Then  I fill in the "Email" field with "newuser@tamu.edu"
        And   I submit the form with button "Create Admin"
        Then  I should see the admin's details with email "newuser@tamu.edu"
        And   I submit the form with button "Delete this Admin"
        Then  I should see the admin list page

    Scenario: Navigate to Admin List page as a non super user admin
        Given I am on the welcome page as regular user admin
        When  I should click the dropdown but don't see the "Manage Admins" button
        Then  I try to visit the admin list page as a non super user admin