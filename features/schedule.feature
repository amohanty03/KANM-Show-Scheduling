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
