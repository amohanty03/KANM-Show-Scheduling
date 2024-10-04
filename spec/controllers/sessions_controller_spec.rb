# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
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


  describe 'GET #logout' do
  before do
    mock_user_sign_in
  end

  it 'redirects to the login page with a notice' do
    get :logout
    expect(response).to redirect_to(login_path)
  end
end

describe 'GET #omniauth' do

  context 'when the admin exists' do
    before do
      mock_user_sign_in
    end

    it 'logs in the admin and redirects to the welcome page' do
      get :omniauth
      expect(session[:admin_id]).to eq(Admin.find_by(uin: '123456789').id)
      expect(flash[:notice]).to eq('You are logged in.')
      expect(response).to redirect_to(welcome_path)
    end
  end

end


end
