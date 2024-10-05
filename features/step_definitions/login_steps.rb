# frozen_string_literal: true

Given('I am on home page') do
    visit login_path
end
  
Then('I should see the home page') do
  expect(page).to have_current_path(login_path)
  expect(page).to have_content('Welcome to the KANM Radio Show Scheduler')
end

Given('I am on the login page') do
  visit login_path
end

When('I click the {string} button as {string} with name {string} {string}') do |login, email, first_name, last_name|
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '1234567890',
    info: {
      email: email,
      first_name: first_name,
      last_name: last_name,
    }
  })
  click_button(login)
end


When('I select a {string} email with name {string} {string}') do |email, first_name, last_name|
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '1234567890',
        info:{
            email: email,
            first_name: first_name,
            last_name: last_name,
        }
    })
    visit '/auth/google_oauth2/callback'
end


Then('I should be redirected to the welcome page') do
  expect(page).to have_current_path(welcome_path)
  expect(page).to have_content('Please upload your RJ Preferences Spreadsheet below')
end

Then('I should stay on the login page') do
  expect(page).to have_current_path(login_path)
  expect(page).to have_content('Welcome to the KANM Radio Show Scheduler')
end


Then('I check if the email is in the database') do
    email = OmniAuth.config.mock_auth[:google_oauth2]['info']['email'] 
    user = Admin.find_by(email: email)

    if user
        puts "Email #{email} exists in the database."
    else
        puts "Email #{email} does not exist in the database"
    end
end
# When('I select a non-tamu.edu email') do
#     OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
#         provider: 'google_oauth2',
#         uid: '1234567890',
#         info: {
#             email: 'user@gmail.com',
#             first_name: 'Test',
#             last_name: 'User'
#         }
#     })
#     visit '/auth/google_oauth2/callback'  
# end





# Then('I should see an error message') do
#     expect(page).to have_content('Wrong email address')
# end
