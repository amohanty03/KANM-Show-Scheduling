Feature: Login
    People can login as admin

Scenario: User is on the login page
    Given I am on home page
    Then  I should see the home page

Scenario: Successful login with a tamu.edu email
    Given I am on the login page
    When  I click the "Login with TAMU Gmail" button as "student@tamu.edu" with name "student" "test"
    And   I select a "student@tamu.edu" email with name "student" "test"
    Then  I should be redirected to the welcome page
#   And   I should see a welcome message

Scenario: Unsuccessful login with a non-tamu.edu email
    Given I am on the login page
    When  I click the "Login with TAMU Gmail" button as "user@gmail.com" with name "user" "test"
    And   I select a "user@gmail.com" email with name "user" "test"
    Then  I should stay on the login page
    # And   I should see an error message

# Scenario: Unsuccessful login with a non-registered tamu.edu email
    Given I am on the login page
    When  I click the "Login with TAMU Gmail" button as "student2@tamu.edu" with name "student2" "test"
    And   I select a "student2@tamu.edu" email with name "student2" "test"
    Then  I should stay on the login page
#     And   I should see an error message

# Scenario: Check if the tamu.edu email is in the database
#     Given I am on the login page
#     When  I click the login button
#     And   I select a tamu.edu email
#     Then  I check if the email is in the database
