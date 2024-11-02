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

Given("there is a schedule entry for {string} at {string}") do |day, hour|
    ScheduleEntry.create(day: day, hour: hour, show_name: 'Show A', last_name: 'Doe', jockey_id: 1)
end

Given("no schedule entry exists for {string} at {string}") do |day, hour|
    ScheduleEntry.where(day:, hour: hour).destroy_all
end

Given("a radio jockey with a show name {string} and last name {string} is available") do |show_name, last_name|
    @jockey_create = RadioJockey.new(show_name: show_name, last_name: last_name)
end

Given("I have the day {string}") do |day|
    @day_name = day
end

Given("the following schedule") do |table|
    table.hashes.each do |row|
        ScheduleEntry.create(
            day: row['day'],
            hour: row['hour'],
            show_name: row['show_name']
        )
    end
end

When("I print the final schedule") do
    @output = capture_output do
        ScheduleProcessor.print_final_schedule
    end
end

When("I add an entry for {string} at {string}") do |day, hour|
    ScheduleProcessor.add_entry(day, hour, @jockey_create)
end

When("I assemble the alternate times") do
    @assemble_alt_times = ScheduleProcessor.assemble_alt_times(@radio_jockey)
end

When("I check for an available time slot for {string} at {int}") do |day, hour|
    @result = ScheduleProcessor.is_available_db(day, hour)
end

When("I convert the day to a number") do
    @day_num = ScheduleProcessor.num_from_day(@day_name)
end

Then("I should see the schedule printed") do |table|
    table.hashes.each do |row|
        expect(@output).to include(row['day'])
        expect(@output).to include (row['hour'])
        expect(@output).to include (row['show_name'])
    end
end

Then("the schedule should be updated with show name {string}, last name {string}") do |show_name, last_name|
    entry = ScheduleEntry.find_by(day: "Monday", hour: 10)
    expect(entry.show_name).to eq(show_name)
    expect(entry.last_name).to eq(last_name)
end

Then("the schedule should not be updated") do
    entry = ScheduleEntry.find_by(day: "Tuesday", hour: 11)
    expect(entry).to be_nil
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
Then("I should get number {int}") do |num|
    expect(@day_num).to eq(num)
end

Then("I should see an {string} message") do |message|
    expect { ScheduleProcessor.num_from_day(@day_name) }.to output(/#{message}/).to_stdout
end
