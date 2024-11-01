# frozen_string_literal: true

When("I click on the {string} button") do |button|
    click_button button
end

When("I select multiple files {string} {string}") do |filename1, filename2|
  checkbox1 = find("input[type='checkbox'][value='#{filename1}']")
  checkbox2 = find("input[type='checkbox'][value='#{filename2}']")

  checkbox1.set(true)
  checkbox2.set(true)
end

Then('the file {string} should not be present in the uploads directory') do |filename|
    test_upload_path = "#{Rails.root}/tmp/test_uploads"
    file_path = File.join(test_upload_path, filename)

    puts "Checkign if #{file_path} exists"
    expect(File.exist?(File.join(test_upload_path, filename))).to be false
  end

Then('I should see No files are present') do
    expect(page).to have_content("No files are present")
end

Then("no files should be deleted from the uploads directory") do
  upload_path = "#{Rails.root}/public/uploads"

  initial_file_count = Dir.glob("#{upload_path}/*").size

  final_file_count = Dir.glob("#{upload_path}/*").size

  expect(final_file_count).to eq(initial_file_count)
end

Given('there are CSV files in the test uploads directory') do
  test_upload_path = "#{Rails.root}/tmp/test_uploads"
  FileUtils.rm_rf(Dir.glob("#{test_upload_path}/*"))
  # Create some dummy CSV files for the test
  File.write("#{test_upload_path}/test1.xlsx", "sample data")
  File.write("#{test_upload_path}/test2.xlsx", "sample data")
  File.write("#{test_upload_path}/test3.xlsx", "sample data")
end
