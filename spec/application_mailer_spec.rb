# spec/mailers/application_mailer_spec.rb
require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe 'default settings' do
    it 'has a default from address' do
      expect(ApplicationMailer.default[:from]).to eq('from@example.com')
    end
  end
end