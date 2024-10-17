# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DownloadController, type: :controller do
  before(:all) do
    Admin.destroy_all
    Admin.create(email: 'jnojek13@tamu.edu', uin: '226005385', first_name: 'Jamie', last_name: 'Nojek')
    OmniAuth.config.test_mode = true
    download_path = Rails.root.join('tmp', 'test_downloads')
    FileUtils.rm_rf(download_path) # Remove the directory and its contents
    FileUtils.mkdir_p(download_path) # Recreate the directory
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
      email: 'user@tamu.edu',
      first_name: 'Test',
      last_name: 'User',
      uin: '123456789',
      role: 1
    )
    session[:admin_id] = admin.id
    allow(controller).to receive(:current_logged_in_admin).and_return(admin)
  end

  describe 'GET #download' do
    context 'when files are selected' do
      before do
        test_upload_path = "#{Rails.root}/tmp/test_uploads"
        FileUtils.mkdir_p(test_upload_path)
        File.write("#{test_upload_path}/test1.csv", "sample data")
        File.write("#{test_upload_path}/test2.csv", "sample data")
      end
      # delete previous run

      it 'creates a zip file' do
        old_controller = @controller
        @controller = WelcomeController.new
        get :index
        @controller = old_controller
        expect(response).to redirect_to(login_path)
        mock_user_sign_in
        old_controller = @controller
        @controller = WelcomeController.new
        get :index
        @controller = old_controller

        zipfile_path = Rails.root.join("tmp", "test_downloads", "archived_files.zip")

        get :download, params: { selected_files: [ 'test1.csv', 'test2.csv' ] }
        expect(File.exist?(zipfile_path)).to be true
      end
    end

    context 'when no files are selected' do
      it 'redirects to index with alert' do
        old_controller = @controller
        @controller = WelcomeController.new
        get :index
        @controller = old_controller
        expect(response).to redirect_to(login_path)
        mock_user_sign_in
        old_controller = @controller
        @controller = WelcomeController.new
        get :index
        @controller = old_controller
        get :download, params: { selected_files: [] }
        expect(response).to redirect_to(welcome_path)
        expect(flash[:alert]).to match(/No file selected/)
      end
    end
  end
end
