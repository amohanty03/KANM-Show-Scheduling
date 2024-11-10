# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UploadsController, type: :controller do
  before(:all) do
    Admin.destroy_all
    Admin.create(email: 'jnojek13@tamu.edu', uin: '226005385', first_name: 'Jamie', last_name: 'Nojek')
    OmniAuth.config.test_mode = true
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
      email: 'user@tamu.edu',
      first_name: 'Test',
      last_name: 'User',
      uin: '123456789',
      role: 1
    )
    session[:admin_id] = admin.id
    allow(controller).to receive(:current_logged_in_admin).and_return(admin)
  end

  describe 'POST #uploads' do
    context 'with valid parameters' do
      it 'uploads a CSV file successfully' do
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
      expect(response).to render_template('welcome/index')

      file = fixture_file_upload('test1.xlsx', 'application/vnd.ms-excel')

      post :handle_upload, params: { upload: { csv_file: file } }

      expect(response).to redirect_to(welcome_path)
      expect(flash[:notice]).to eq('File uploaded successfully.')

      expect(File.exist?(Rails.root.join('tmp/test_uploads/test1.xlsx'))).to be true
      end
    end

    context 'with invalid parameters' do
      it 'does not upload an invalid file type' do
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
        expect(response).to render_template('welcome/index')
        file = fixture_file_upload('test2.txt', 'text/plain')

        post :handle_upload, params: { upload: { csv_file: file } }

        expect(flash[:alert]).to eq("Invalid file type. Please choose a xlsx file to upload.")
        expect(File.exist?(Rails.root.join('tmp/test_uploads/test2.txt'))).to be false
      end
    end

    context 'with no files selected' do
      it 'does not upload an invalid file type' do
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
        expect(response).to render_template('welcome/index')

        post :handle_upload, params: { upload: { csv_file: "" } }

        expect(flash[:alert]).to eq("Invalid file type. Please choose a xlsx file to upload.")
        expect(File.exist?(Rails.root.join('tmp/test_uploads/test2.txt'))).to be false
      end
    end


    context 'with invalid parameters' do
      it 'does not upload a file with a long name' do
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
        expect(response).to render_template('welcome/index')
        file = fixture_file_upload('ThisIsAFileWithAVeryLongNameThatItShouldBeRejectedDoNotUploadThisFile.xlsx', 'application/vnd.ms-excel')

        post :handle_upload, params: { upload: { csv_file: file } }

        expect(flash[:alert]).to eq("File name is too long. Please rename the file and try again.")
        expect(File.exist?(Rails.root.join('tmp/test_uploads/ThisIsAFileWithAVeryLongNameThatItShouldBeRejectedDoNotUploadThisFile.xlsx'))).to be false
      end
    end

    context 'with invalid parameters' do
      it 'does not upload a file with the same name' do
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
        expect(response).to render_template('welcome/index')
        FileUtils.touch('tmp/test_uploads/RJ_Simple_Sample_Test.xlsx')
        file = fixture_file_upload('RJ_Simple_Sample_Test.xlsx', 'text/plain')
        post :handle_upload, params: { upload: { csv_file: file } }

        expect(flash[:alert]).to eq("There is a file with the same name. Please rename the file and try again.")
      end
    end
  end
end
