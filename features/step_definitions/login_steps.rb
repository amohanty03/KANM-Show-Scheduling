# frozen_string_literal: true

# steps for logging in 

Given('I am on the login page') do
    visit login
end

When('I click the {string} button') do 
    click_link('Login with TAMU Gmail')
end

When('I select a tamu.edu email') do
    #authentication process for valid email
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '1234567890',
        info:{
            email: 'student@tamu.edu',
            name: 'Test student'
        }
    })

    visit '/auth/google_oauth2/callback'
end

When('I select a non-tamu.edu email') do

    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AutoHash.new({
        provider: 'google_oauth2',
        uid: '1234567890',
        info: {
            email: 'user@gmail.com',
            name: 'Test user'
        }
    })

    visit '/autyh/google_oauth2/callback'
end
Then('I check if the email is in the database') do
    email = OmniAuth.config.mock_aut[:google_oauth2]['info']['email']
    user = User.find_by(email: email)

    if user
        puts "Email #{email} exists in the database."
    else
        puts "Email #{email} does not exist in the database"
    end
end

Then('I should be redirected to the welcome page') do
    expect(page).to have_current_path(welcome)
end

Then('I should see a welcome page') do
    expect(page).to have_current_path(welcome)
end

Then('I should stay on the login page') do
    expect(page).to have_current_path(login)
end

Then('I should see an error message') do
    expect(page).to have_content('Wrong email address')
end
 
