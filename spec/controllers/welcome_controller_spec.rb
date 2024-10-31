# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  before(:all) do
    Admin.destroy_all
    Admin.create(email: 'jnojek13@tamu.edu', uin: '226005385', first_name: 'Jamie', last_name: 'Nojek')
    OmniAuth.config.test_mode = true
  end

  let(:valid_auth_hash) {
    OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456',
      info: {
        email: 'user@tamu.edu',
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
      uin: '123456789'
    )
    allow(controller).to receive(:current_logged_in_admin).and_return(admin)
  end

  describe 'GET #index' do
    before do
      mock_user_sign_in
      get :index
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    context 'when no files are present' do
      before do
      test_upload_path = "#{Rails.root}/tmp/test_uploads"
      FileUtils.mkdir_p(test_upload_path)
      FileUtils.rm_rf(Dir.glob("#{test_upload_path}/*"))

        get :index
      end

      it 'assigns an empty array to @csv_files' do
        expect(assigns(:csv_files)).to be_empty
      end
    end

    context 'when files are present' do
      before do
        test_upload_path = "#{Rails.root}/tmp/test_uploads"
        FileUtils.mkdir_p(test_upload_path)
        File.write("#{test_upload_path}/test1.csv", "sample data")
        File.write("#{test_upload_path}/test2.csv", "sample data")
      end

      it 'displays the files correctly' do
        get :index
        expect(assigns(:csv_files).map { |file| File.basename(file) }).to include('test1.csv', 'test2.csv')
      end

      it 'selecting a file marks it as selected' do
        selected_files = [ 'test1.csv' ]
        allow(controller).to receive(:params).and_return({ selected_files: selected_files })

        get :index
        expect(assigns(:csv_files)).to include("#{Rails.root}/tmp/test_uploads/test1.csv")
      end
    end
  end

  describe 'POST #handle_files' do
    before { mock_user_sign_in }
    before do
      test_upload_path = "#{Rails.root}/tmp/test_uploads"
      FileUtils.mkdir_p(test_upload_path)
      File.write("#{test_upload_path}/test1.csv", "sample data")
      File.write("#{test_upload_path}/test2.csv", "sample data")
    end
    context 'when files are selected for deletion' do
      it 'deletes the selected files' do
        expect {
          post :handle_files, params: { selected_files: [ 'test1.csv', 'test2.csv' ], action_type: 'delete_files' }
      }.to change { Dir.glob("#{Rails.root}/tmp/test_uploads/*").size }.by(-2) # expect two files to be deleted
      end

      it 'sets a flash notice message' do
        post :handle_files, params: { selected_files: [ 'test1.csv', 'test2.csv' ], action_type: 'delete_files' }
        expect(flash[:notice]).to eq("Selected files have been deleted.")
      end
    end

    context 'when no files are selected for deletion' do
      it 'does not delete any files and sets an alert message' do
        expect {
          post :handle_files, params: { selected_files: [], action_type: 'delete_files'  }
        }.not_to change { Dir.glob("#{Rails.root}/tmp/test_uploads/*").size }

        expect(flash[:alert]).to eq("No files selected for deletion.")
      end
    end

    context 'when exactly one file is selected to generate schedule' do
      it 'generates a schedule' do
        test_do_not_delete_path = "#{Rails.root}/spec/fixtures/files/CleanTestData.xlsx"
        test_upload_path = "#{Rails.root}/tmp/test_uploads"
        FileUtils.cp(test_do_not_delete_path, test_upload_path)
        post :handle_files, params: { selected_files: '/CleanTestData.xlsx', action_type: 'generate_schedule'  }
      end
    end

    context 'when no files are selected to generate schedule' do
      it 'does not generate a schedule and sets an alert message' do
        post :handle_files, params: { selected_files: [], action_type: 'generate_schedule'  }
        expect(flash[:alert]).to eq("Please select exactly one file to parse.")
        expect(response).to redirect_to(welcome_path)
      end
    end

    context 'when more than one file are selected to generate schedule' do
      it 'does not generate a schedule and sets an alert message' do
        post :handle_files, params: { selected_files: [ 'test1.csv', 'test2.csv' ], action_type: 'generate_schedule'  }
        expect(flash[:alert]).to eq("Please select exactly one file to parse.")
        expect(response).to redirect_to(welcome_path)
      end
    end
  end
end
