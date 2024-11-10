# features/step_definitions/upload_steps.rb

When("I upload a valid CSV file") do
  visit welcome_path
  attach_file('upload[csv_file]', Rails.root.join('spec/fixtures/files/RJ_Simple_Sample_Test.xlsx'))
  click_button "Upload"
end

When("I upload an invalid file type") do
  visit welcome_path
  attach_file('upload[csv_file]', Rails.root.join('spec/fixtures/files/test2.txt'))
  click_button 'Upload'
end

Then("the file {string} should be saved in {string}") do |filename, path|
  expect(File.exist?(Rails.root.join(path, filename))).to be true
end

Then("no files are uploaded") do
  expect(File.exist?(Rails.root.join("tmp/test_uploads", 'test2.txt'))).to be false
end

When("I click {string} without selecting a file") do |button|
  visit welcome_path
  click_button button
end

Then("I should see a warning {string}") do |message|
  expect(File.exist?(Rails.root.join("tmp/test_uploads", 'test2.txt'))).to be false
  expect(page).to have_content(message)
end

When("I upload a file with a long name") do
  visit welcome_path
  attach_file('upload[csv_file]', Rails.root.join('spec/fixtures/files/ThisIsAFileWithAVeryLongNameThatItShouldBeRejectedDoNotUploadThisFile.xlsx'))
  click_button 'Upload'
end

Then("I should see a warning message {string}") do |message|
  expect(File.exist?(Rails.root.join("tmp/test_uploads", 'ThisIsAFileWithAVeryLongNameThatItShouldBeRejectedDoNotUploadThisFile.xlsx'))).to be false
  expect(page).to have_content(message)
end

When("I upload a file with the same name") do
  visit welcome_path
  FileUtils.touch('tmp/test_uploads/RJ_Simple_Sample_Test.xlsx')
  attach_file('upload[csv_file]', Rails.root.join('spec/fixtures/files/RJ_Simple_Sample_Test.xlsx'))
  click_button 'Upload'
end

Then("I should see this warning {string}") do |message|
  expect(page).to have_content(message)
end
