Feature: Login
    People can login as admin

Scenario: User is on the login page
    Given I am on home page
    Then  I should see the home page

Scenario: Successful login with a tamu.edu email
    Given I am on the login page
    When  I click the 'Login with TAMU Gmail' button
    And   I select a tamu.edu email
    Then  I should be redirected to the welcome page
    And   I should see a welcome message

Scenario: Unsuccessful login with a non-registered tamu.edu email
    Given I am on the login page
    When  I click the 'Login with TAMU Gmail' button
    And   I select a tamu.edu email that is not registered
    Then  I shoul stay on the login page
    And   I should see an error message

Scenario: Unsuccessful login with a non-tamu.edu email
    Given I am on the login page
    When  I click the "Login with TAMU Gmail" button
    And   I select a nontamu.edu email
    Then  I should stay on the login page
    And   I should see an error message

Scenario: Check if the tamu.edu email is in the database
    Given I am on the login page
    When  I click the login button
    And   I select a tamu.edu email
    Then  I check if the email is in the database
