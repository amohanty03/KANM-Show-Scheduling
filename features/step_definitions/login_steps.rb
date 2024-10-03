# frozen_string_literal: true

# steps for logging in 

Given('I am not logged in') do
    nil
end

When('I enter my username as {string}') do |username|
    @username = username
end

When('I enter my password as {string}') do |password|
    @password = password
end

When('I click the login button') do
    if @username.nil? || @username.empty?
        @output = "Error: username cannot be empty"
    elsif @passwrod.nil? || @password.empty?
        @output, = request("login #{@username}")
    else
        @output, = request("login #{@username} #{@password}")

        if @output.include?("Invalid credentials")
            @output = "Error: Invalid username or password."
        end
    end
end


Then('I should see {string}') do |expected_output|
    expect(@output).to include(expected_output)
end