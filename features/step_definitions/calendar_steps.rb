# frozen_string_literal: true

Given("I visit the calendar index with the day {string}") do |day|
  visit calendar_path(day: day)
end

Then("I should see the selected day as {string}") do |day|
  expect(page).to have_content(day)
end

# Commenting out since we are now showing only filled time slots
# Then("I should see time slots for the whole day") do
#   (0..23).each do |hour|
#     start_time = "#{format('%02d', hour)}:00"
#     end_time = hour == 23 ? "00:00" : "#{format('%02d', hour + 1)}:00"
#     expect(page).to have_content("#{start_time} - #{end_time}")
#   end
# end

Then("I should see no time slots for the whole day") do
  expect(page).to have_content("Time Slot")
  expect(page).to have_content("Details")
  expect(page).not_to have_content("Show Name:")
  expect(page).not_to have_content("DJ Name:")
end

Then("I click on the {string} button in the calendar page") do |export|
  click_link(export)
end

Then("I should see the downloaded file {string}") do |filename|
  download_path = Rails.root.join('tmp', 'test_downloads', filename)
  expect(File).to exist(download_path)
end

Given("I am on the calendar page") do
  visit calendar_path
end

Then("I should see the {string} link") do |link_text|
  expect(page).to have_link(link_text, visible: true)
end

When("I click on the download unassigned RJ list button") do
  click_button "Download Unassigned RJ List"
end

Then("I should be able to download an Excel file containing the unassigned RJ list") do
  expect(page.response_headers['Content-Type']).to include('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
end


When("I upload a CSV file with just two entries") do
  attach_file('upload[csv_file]', Rails.root.join('spec/fixtures/files/RJ_Two_Entries.xlsx'))
  click_button "Upload"
end

When("I check the checkbox for {string}") do |filename|
  checkbox = find("input[type='checkbox'][value='#{filename}']")
  checkbox.check
end

When('I click the {string} button to generate the schedule') do |button|
  click_button button
end

Then("I should be taken to the calendar page") do
  expect(page).to have_current_path(calendar_path)
  expect(page).to have_content("Monday") # default
end

Then("I should see 2 filled timeslots") do
  expect(page).to have_content("DJ Mike")
  expect(page).to have_content("DJ DKS")
  expect(page).to have_content("Paper Jams")
  expect(page).to have_content("The Schrute Effect")
  expect(page).to have_content("17:00 - 18:00")
  expect(page).to have_content("18:00 - 19:00")
end
