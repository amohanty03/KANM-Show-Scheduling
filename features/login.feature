Feature: Login
 People can login as admin
 
 Scenario: Login with username and password
  Given I am not logged in and I have a person with username "test1@tamu.edu" and password "password"
  When I enter my username as "test1@tamu.edu"
  And I enter my username as "password"
  When I click the login button
  Then I should see "admin"
 
 Scenario: Login with incorrect password
  Given I am not logged in and I have a person with username "test1@tamu.edu" and password "password" 
  When I enter my username as "test1@tamu.edu"
  And I enter my password as "dasworp"
  When I click the login button 
  Then I should see "access denied: incorrect username or password"
 
 Scenario: Login with only username
  Given I am not logged in and I have a person with username "test1@tamu.edu" and password "password"
  When I enter my username as "test1@tamu.edu"
  And I enter my password as "" 
  When I click the login button
  Then I should see "access denied: incorrect username or password"
 
 Scenario: Login with an empty username
  Given I am not logged in and I have a person with username "test1@tamu.edu" and password "password" 
  When I enter my username as ""
  And I enter my password as "password"
  When I click the login button
  Then I should see "acess denied: incorrect usernameername or password"
 
 Scenario: Login with wrong username or password
  Given I am not logged in and I have a person with username "test1@tamu.edu" and password "password"
  When I enter my username as "wronguser"
  And I enter my password as "wrongpassword"
  When I click the login button
  Then I should see "access denied: incorrect username or password"