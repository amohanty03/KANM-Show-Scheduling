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
    before do
      # Sample data setup
      @rj1 = RadioJockey.create(
        first_name: 'John',
        last_name: 'Doe',
        uin: '123456789',
        expected_grad: '2025/05',
        member_type: 'Returning DJ',
        retaining: 'Yes',
        semesters_in_kanm: '2',
        show_name: 'Show A',
        dj_name: 'DJ John',
        best_day: 'Monday',
        best_hour: '10:00',
        alt_mon: '',
        alt_tue: '',
        alt_wed: '',
        alt_thu: '',
        alt_fri: '',
        alt_sat: '',
        alt_sun: '',
        un_jan: '',
        un_feb: '',
        un_mar: '',
        un_apr: '',
        un_may: ''
      )
      @rj2 = RadioJockey.create(
        first_name: 'Jane',
        last_name: 'Doe',
        uin: '123456789',
        expected_grad: '2025/05',
        member_type: 'Returning DJ',
        retaining: 'Yes',
        semesters_in_kanm: '2',
        show_name: 'Show B',
        dj_name: 'DJ Jane',
        best_day: 'Monday',
        best_hour: '11:00',
        alt_mon: '',
        alt_tue: '',
        alt_wed: '',
        alt_thu: '',
        alt_fri: '',
        alt_sat: '',
        alt_sun: '',
        un_jan: '',
        un_feb: '',
        un_mar: '',
        un_apr: '',
        un_may: ''
      )

      # Sample schedule entries for "Monday"
      ScheduleEntry.create(day: 'Monday', hour: '10:00', show_name: 'Show A', last_name: 'Doe', jockey_id: 1)
      ScheduleEntry.create(day: 'Monday', hour: '11:00', show_name: 'Show B', last_name: 'Doe', jockey_id: 2)
    end

    context 'when day parameter is not provided' do
      it 'defaults to Monday' do
        get :index
        expect(assigns(:selected_day)).to eq 'Monday'
      end
    end
  end
end
