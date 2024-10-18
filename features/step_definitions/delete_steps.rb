# frozen_string_literal: true

When("I click on the delete button") do
    click_button "Delete"
  end

Then('the file {string} should not be present in the uploads directory') do |filename|
    test_upload_path = "#{Rails.root}/tmp/test_uploads"
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
