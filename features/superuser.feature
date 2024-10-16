Feature: Superuser Admin Management
    As a superuser
    I want to manage admin accounts
    So that I can maintain control over user access

    Scenario: Successful login with a tamu.edu email
        Given I am on the login page
        When  I click the "Login with TAMU Gmail" button as "superuser@tamu.edu" with name "Super" "User"
        And   I select a "superuser@tamu.edu" email with name "Super" "User"
        Then  I should be redirected to the welcome page
