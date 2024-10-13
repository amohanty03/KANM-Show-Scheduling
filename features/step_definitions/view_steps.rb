# frozen_string_literal: true

Given("I visit the welcome page") do
  visit welcome_path
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

Given('there are no CSV files in the test uploads directory') do
  test_upload_path = "#{Rails.root}/tmp/test_uploads" # Ensure the test uploads directory is empty
  FileUtils.mkdir_p(test_upload_path)
  FileUtils.rm_rf(Dir.glob("#{test_upload_path}/*")) # Remove any existing files
end

Then('I should see No files are present') do
  expect(page).to have_content("No files are present")
end

Given('there are some CSV files in the test uploads directory') do
  test_upload_path = "#{Rails.root}/tmp/test_uploads" # Path to the test uploads directory
  FileUtils.rm_rf(Dir.glob("#{test_upload_path}/*"))
  # Create some dummy CSV files for the test
  File.write("#{test_upload_path}/test1.csv", "Test data 1")
  File.write("#{test_upload_path}/test2.csv", "Test data 2")
end

Then('I should see the uploaded files listed') do
  expect(page).to have_content("test1.csv")
  expect(page).to have_content("test2.csv")
end

When('I select the file {string}') do |filename|
  checkbox = find("input[type='checkbox'][value='#{filename}']")
  checkbox.check unless checkbox.checked?
end

Then('the file {string} should be marked as selected') do |filename|
  expect(find("input[value='#{filename}']")).to be_checked
end
