# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UploadsController, type: :controller do
  before(:all) do
    Admin.destroy_all
    Admin.create(email: 'jnojek13@tamu.edu', uin: '226005385', first_name: 'Jamie', last_name: 'Nojek')
    OmniAuth.config.test_mode = true
  end

  before(:each) do
    upload_path = Rails.root.join('tmp', 'test_uploads')
    FileUtils.rm_rf(upload_path) # Remove the directory and its contents
    FileUtils.mkdir_p(upload_path) # Recreate the directory
  end

  let(:valid_auth_hash) {
    OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456',
      info: {
        email: 'user@example.com',
        name: 'Test User'
      },
      credentials: {
        token: 'mock_token',
        refresh_token: 'mock_refresh_token'
      }
    })
  }

  def mock_user_sign_in
    request.env['omniauth.auth'] = valid_auth_hash
    admin = Admin.create!(
      email: 'user@example.com',
      first_name: 'Test',
      last_name: 'User',
      uin: '123456789'
    )
    allow(controller).to receive(:current_admin).and_return(admin)
  end

  describe 'POST #create' do
    before do
      mock_user_sign_in
    end
    context 'with valid parameters' do
      it 'uploads a CSV file successfully' do
        file = fixture_file_upload('test.csv', 'text/csv')

        post :create, params: { upload: { csv_file: file } }

        expect(response).to redirect_to(welcome_path)
        expect(flash[:notice]).to eq('File uploaded successfully.')
        expect(File.exist?(Rails.root.join('tmp/test_uploads/test.csv'))).to be true
      end
    end

    context 'with invalid parameters' do
      it 'does not upload an invalid file type' do
        file = fixture_file_upload('test.txt', 'text/plain')

        post :create, params: { upload: { csv_file: file } }

        expect(response).to redirect_to(welcome_path)
      end
    end
  end
end