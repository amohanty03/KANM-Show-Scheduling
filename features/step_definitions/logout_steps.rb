# frozen_string_literal: true

# Scenario: Admin logout from welcome page
Given('I am on welcome page') do
    visit welcome_path
end

Then('I should see the Logout button') do
    expect(page).to have_button('Logout')
end

When('I click {string}') do |button|
    click_button button
end

Then('I should go back to the login page') do
    expect(current_path).to eq(login_path)
end

# Scenario: Admin logout from admins page
Given('I am on admins page') do
    visit admins_path
end

Then('I should see ${string}') do |text|
    expect(page).to have_content(text)
end
