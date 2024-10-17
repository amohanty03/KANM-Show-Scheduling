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
end
