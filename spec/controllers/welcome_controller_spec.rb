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
end
