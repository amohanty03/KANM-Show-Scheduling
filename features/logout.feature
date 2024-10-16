Feature: Logout
    Admin can logout

Background: Successful login with a tamu.edu email
  Given I am on the login page
  When  I click the "Login with TAMU Gmail" button as "student@tamu.edu" with name "student" "test"
  And   I select a "student@tamu.edu" email with name "student" "test"
  Then  I check if the email is in the database
  Then  I should be redirected to the welcome page

Scenario: Admin logout from welcome page
  Given I am on welcome page
  Then  I should see the Logout button
  When  I click "Logout"
  Then  I should go back to the login page
