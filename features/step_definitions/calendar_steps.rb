# frozen_string_literal: true

Given("I visit the calendar index with the day {string}") do |day|
  visit calendar_path(day: day)
end

Then("I should see the selected day as {string}") do |day|
  expect(page).to have_content(day)
end

Then("I should see time slots for the whole day") do
  (0..23).each do |hour|
    start_time = "#{format('%02d', hour)}:00"
    end_time = hour == 23 ? "00:00" : "#{format('%02d', hour + 1)}:00"
    expect(page).to have_content("#{start_time} - #{end_time}")
  end
end

Then("I click on the {string} button in the calendar page") do |export|
  click_link(export)
end

Then("I should see the downloaded file {string}") do |filename|
  download_path = Rails.root.join('tmp', 'test_downloads', filename)
  expect(File).to exist(download_path)
end
