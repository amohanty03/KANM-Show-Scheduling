# frozen_string_literal: true

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
