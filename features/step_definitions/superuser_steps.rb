Given('I am on the welcome page') do
  visit login_path
  click_button("Login with TAMU Gmail")
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '1234567890',
    info: {
      email: 'superuser@tamu.edu',
      first_name: 'Super',
      last_name: 'User'
    }
  })
  visit '/auth/google_oauth2/callback'
  expect(page).to have_current_path(welcome_path)
end

When('I should click the dropdown {string} button') do |button_text|
  find('.dropdown').click
  click_link(button_text)
end

Then('I should see the admin list page') do
  expect(page).to have_current_path(admins_path)
  expect(page).to have_content('Admins')
  expect(page).to have_content('Show this admin')
  expect(page).to have_content('New admin')
  expect(page).to have_content('Back to Welcome Page')
  expect(page).to have_selector('.dropdown')
  expect(page).to have_link('Manage Admins')
end

Given('I am on the Admin list page') do
  visit login_path
  click_button("Login with TAMU Gmail")
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '1234567890',
    info: {
      email: 'superuser@tamu.edu',
      first_name: 'Super',
      last_name: 'User'
    }
  })
  visit '/auth/google_oauth2/callback'
  visit admins_path
  expect(page).to have_current_path(admins_path)
end

When('I click the first {string} link') do |link_text|
  all(:link, link_text)[0].click
end

Then('I should see the admin\'s details with email {string}') do |email|
  expect(page).to have_content('Email')
  expect(page).to have_content(email)
  expect(page).to have_content('Edit this Admin')
  expect(page).to have_content('Back to Admin List')
  expect(page).to have_content('Delete this Admin')
  expect(page).to have_selector('.dropdown')
  expect(page).to have_link('Manage Admins')
  expect(page).to have_selector('.dropdown')
end

When('I click the {string} link') do |link|
  click_link(link)
end

Then('I am on the Edit Admin Page for admin with email {string}') do |admin_email|
  @admin = Admin.find_by(email: admin_email)
  expect(page).to have_current_path(edit_admin_path(@admin))
end

When('I fill in the {string} field with {string}') do |field, value|
  fill_in field, with: value
end

When('I fill in the {string} field INCORRECTLY with {string}') do |field, incorrect_value|
  fill_in field, with: incorrect_value
end

And('I submit the form with button {string}') do |button|
  click_button button
end

And('I should see the updated Uin {string}') do |uin|
  expect(page).to have_content(uin)
end

Then('I should see an error has occurred while {string} admin') do |string|
  expect(page).to have_content("must be a TAMU email address ending with @tamu.edu")
end

Given('I am on the welcome page as regular user admin') do
  visit login_path
  click_button("Login with TAMU Gmail")
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '1234567890',
    info: {
      email: 'student@tamu.edu',
      first_name: 'Test',
      last_name: 'Student'
    }
  })
  visit '/auth/google_oauth2/callback'
  expect(page).to have_current_path(welcome_path)
end

When('I should click the dropdown but don\'t see the {string} button') do |button_text|
  find('.dropdown').click
  expect(page).not_to have_content(button_text)
end

Then('I try to visit the admin list page as a non super user admin') do
  visit admins_path
  expect(page).to have_current_path(welcome_path)
end