Given("a Radio Jockey with alt times for each day") do
    @radio_jockey = RadioJockey.new(
        alt_mon: "1; 3; 7; 8",
        alt_tue: "1; 2; 3",
        alt_wed: "3; 5; 7; 8",
        alt_thu: "5; 6; 10; 12",
        alt_fri: "5; 8; 10; 13",
        alt_sat: "9; 10; 14; 20",
        alt_sun: "12; 15; 16; 17"
    )
end

When("I assemble the alternate times") do
    @assemble_alt_times = ScheduleProcessor.assemble_alt_times(@radio_jockey)
end

Then("I should get a list of alt times for each day of the week") do
    expected_times = {
        Monday: [ "1", "3", "7", "8" ],
        Tuesday: [ "1", "2", "3" ],
        Wednesday: [ "3", "5", "7", "8" ],
        Thursday: [ "5", "6", "10", "12" ],
        Friday: [ "5", "8", "10", "13" ],
        Saturday: [ "9", "10", "14", "20" ],
        Sunday: [ "12", "15", "16", "17" ]
    }

    expect(@assemble_alt_times).to eq(expected_times)
end

Given("There is a schedule entry for {string} at {string}") do |day, hour|
    ScheduleEntry.create(day: day, hour: hour, show_name: 'Show A', last_name: 'Doe', jockey_id: 1)
end

When("I check for an available time slot for {string} at {string}") do |day, hour|
    @result = ScheduleProcessor.is_available_db(day, hour)
end

Then("I should see that the time slot is not available") do
    expect(@result).to be false
end

Then("I should see that the time slot is available") do
    expect(@result).to be true
end

Given('I have a best time of {int}') do |int|
    @best_time = int
end

Given('I have a range of {int} hours') do |int|
    @range = int
end

Given('I am free {string} at {int}') do |string, int|
    @alt_times = { string => [ int ] }
end

Then('I should see {string} at {int} in the range list') do |string, int|
    range_list = ScheduleProcessor.best_alt_time_ranges(@best_time, @range, @alt_times)
    expect(range_list) == { string => [ int ] }
end

Then('I should not see {string} at {int} in the range list') do |string, int|
    range_list = ScheduleProcessor.best_alt_time_ranges(@best_time, @range, @alt_times)
    expect(range_list) != { string => [ int ] }
end
