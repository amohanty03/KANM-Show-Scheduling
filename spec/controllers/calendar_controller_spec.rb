# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalendarController, type: :controller do
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

  describe 'GET #calendar' do
    context 'when day parameter is not provided' do
      it 'defaults to Monday' do
        get :index
        expect(response).to redirect_to(login_path)
        mock_user_sign_in
        get :index
        expect(response).to render_template('calendar/index')
      end
    end
  end

  describe 'GET #export' do
    before do
      mock_user_sign_in
      allow(ScheduleEntry).to receive(:where).and_return([])
    end

    it 'returns an Excel file with the correct content type and filename' do
      get :export

      expect(response).to have_http_status(:success)
      expect(response.header['Content-Type']).to eq 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      expect(response.header['Content-Disposition']).to include('attachment')
      expect(response.header['Content-Disposition']).to include('Weekly_Schedule.xlsx')
    end
  end
end
