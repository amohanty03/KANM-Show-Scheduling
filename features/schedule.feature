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
    Given There is an unassigned schedule entry for "Tuesday" at "11"
    When I check for an available time slot for "Tuesday" at "11"
    Then I should see that the time slot is available

Scenario: there are alternate times in range
    Given I have a best time of 3
    And I have a range of 3 hours
    And I have a range step of 3 hours
    And I am free "Monday" at 4
    Then I should see "Monday" at 4 in the range list

Scenario: there are no alternate times in range
    Given I have a best time of 3
    And I have a range of 3 hours
    And I have a range step of 3 hours
    And I am free "Monday" at 9
    Then I should not see "Monday" at 9 in the range list


Scenario: convert Monday to 0
    Given I have the day "Monday"
    When I convert the day to a number
    Then I should get number 0

Scenario: convert Tuesday to 1
    Given I have the day "Tuesday"
    When I convert the day to a number
    Then I should get number 1

Scenario: convert Wednesday to 2
    Given I have the day "Wednesday"
    When I convert the day to a number
    Then I should get number 2

Scenario: convert Thursday to 3
    Given I have the day "Thursday"
    When I convert the day to a number
    Then I should get number 3

Scenario: convert Friday to 4
    Given I have the day "Friday"
    When I convert the day to a number
    Then I should get number 4

Scenario: convert Saturday to 5
    Given I have the day "Saturday"
    When I convert the day to a number
    Then I should get number 5

Scenario: convert Sunday to 6
    Given I have the day "Sunday"
    When I convert the day to a number
    Then I should get number 6

Scenario: invalid day name
    Given I have the day "something"
    When I convert the day to a number
    Then I should see an "Invalid day!" message

Scenario: Update an existing entry
    Given there is a schedule entry for "Monday" at "10"
    And a radio jockey with a show name "Morning show" and last name "DJ" is available
    When I add an entry for "Monday" at "10"
    Then the schedule should be updated with show name "Morning show", last name "DJ"


Scenario: Print final schedule
    Given the following schedule
    | day     | hour | show_name      |
    | Monday  | 10   | Morning Show   |
    | Tuesday | 12   | Afternoon Show |
    When I print the final schedule
    Then I should see the schedule printed
    | day     | hour | show_name      |
    | Monday  | 10   | Morning Show   |
    | Tuesday | 12   | Afternoon Show |

