# features/step_definitions/upload_steps.rb

When("I upload a valid CSV file") do
  visit welcome_path
  attach_file('upload[csv_file]', Rails.root.join('spec/fixtures/files/test.csv'))
  click_button "Upload"
end

When("I upload an invalid file type") do
  visit welcome_path
  attach_file('upload[csv_file]', Rails.root.join('spec/fixtures/files/test.txt'))
  click_button 'Upload'
end

Then("the file should be saved in {string}") do |path|
  expect(File.exist?(Rails.root.join(path, 'test.csv'))).to be true
end

Then("no files are uploaded") do
  expect(File.exist?(Rails.root.join("tmp/test_uploads", 'test.txt'))).to be false
end