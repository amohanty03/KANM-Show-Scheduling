Given("I upload a valid file") do
  # Create a temporary file in the test uploads directory
  file_path = Rails.root.join('tmp', 'test_uploads', 'valid_file.csv')
  FileUtils.touch(file_path)  # Create a blank file or write valid CSV content
end

When("I choose to {string}") do |action|
  # Simulate the form submission based on the action
  case action
  when "Generate Schedule"
    click_button "Generate Schedule"
  when "Delete Selected Files"
    click_button "Delete Selected Files"
  end
end

Then("I should be redirected to the calendar page") do
  expect(current_path).to eq(calendar_path)
end

Then("I should see an alert {string}") do |alert_message|
  expect(page).to have_content(alert_message)
end

Then("I should see a notice {string}") do |notice_message|
  expect(page).to have_content(notice_message)
end

When("I choose to {string} without selecting a file") do |action|
  # Simulate the form submission based on the action
  case action
  when "Generate Schedule"
    click_button "Generate Schedule"
  end
end
