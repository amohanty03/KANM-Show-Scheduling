# features/step_definitions/download_steps.rb

When("I click the download button for {string}") do |string|
  visit download_path(:download, params: { selected_files: [ string ] })
end

When("I click the download button for no files") do
  click_button "Download"
end

Then("the file {string} should not be saved in {string}") do |filename, path|
  expect(File.exist?(Rails.root.join(path, filename))).to be false
end

Given('there are no files in the test downloads directory') do
  test_download_path = "#{Rails.root}/tmp/test_downloads"
  FileUtils.mkdir_p(test_download_path)
  FileUtils.rm_rf(Dir.glob("#{test_download_path}/*")) # Remove any existing files
end
