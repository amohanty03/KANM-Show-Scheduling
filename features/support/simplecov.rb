# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "/channels/"
  add_filter "/jobs/"
  add_filter "/mailers/"
  #add_filter "admins_controller"
end
