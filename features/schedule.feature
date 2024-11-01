Feature: Algorithm put Radio Jockey in open timeslots


Scenario: parse Alternate timelines for Radio Jockey
    Given a Radio Jockey with alt times for each day
    When I assemble the alternate times
    Then I should get a list of alt times for each day of the week

Scenario: time slot is not available
    Given There is a schedule entry for "Monday" at "10"
    When I check for an available time slot for "Monday" at "10"
    Then I should see that the time slot is not available

Scenario: time slot is available
    When I check if the time slot is available for "Tuesday" at "11"
    Then I should see that the time slot is available

Scenario: there are alternate times in range
    Given I have a best time of 3
    And I have a range of 3 hours
    And I am free "Monday" at 4
    Then I should see "Monday" at 4 in the range list

Scenario: there are no alternate times in range
    Given I have a best time of 3
    And I have a range of 3 hours
    And I am free "Monday" at 9
    Then I should not see "Monday" at 9 in the range list