require 'fileutils'

Before do
  # Ensure the test database is clean and set up with necessary data
  Admin.delete_all

  # Create an admin user that matches the mocked OmniAuth credentials
  # Please maintain this order here
  Admin.create!(
    email: 'superuser@tamu.edu',
    first_name: 'Test',
    last_name: 'Student',
    role: 1
  )
  Admin.create!(
    email: 'student@tamu.edu',
    first_name: 'Test',
    last_name: 'Student'
  )




  # Define the path to the test uploads directory
  upload_path = Rails.root.join('tmp', 'test_uploads')

  # Remove the directory and all its contents if it exists
  FileUtils.rm_rf(upload_path) if Dir.exist?(upload_path)

  # Recreate the directory
  FileUtils.mkdir_p(upload_path)

  # create test
  test_upload_path = "#{Rails.root}/tmp/test_uploads"
  FileUtils.mkdir_p(test_upload_path)
  File.write("#{test_upload_path}/test1.csv", "sample data")
  File.write("#{test_upload_path}/test2.csv", "sample data")
  File.write("#{test_upload_path}/test3.csv", "sample data")
end
