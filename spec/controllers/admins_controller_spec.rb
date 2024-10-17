# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  before(:all) do
    Admin.destroy_all
    Admin.create(email: 'jnojek13@tamu.edu', uin: '226005385', first_name: 'Jamie', last_name: 'Nojek', role: 1)
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
      uin: '123456789',
      role: 1
    )
    session[:admin_id] = admin.id
    allow(controller).to receive(:current_logged_in_admin).and_return(admin)
  end

  describe 'GET #show' do
    context 'when admin is logged in' do
      before do
        mock_user_sign_in
        admin = Admin.find_by(uin: '226005385')
        get :show, params: { id: admin.id }
      end

     it 'assigns the requested admin to @current_admin' do
        expect(response).to render_template(:show)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        admin = Admin.find_by(uin: '226005385')
        get :show, params: { id: admin.id }
        expect(response).to redirect_to(:login)
      end
    end

    context 'when logged-in admin is not a superuser' do
      before do
        # Create a non-superuser admin
        non_superuser_admin = Admin.create!(
          email: 'nonsuperuser@tamu.edu',
          first_name: 'Non',
          last_name: 'Superuser',
          uin: '987654321',
          role: 0 # Assuming 0 is for regular users
        )
        session[:admin_id] = non_superuser_admin.id
        allow(controller).to receive(:current_logged_in_admin).and_return(non_superuser_admin)
      end

      it 'redirects to the welcome page with an alert' do
        get :index
        expect(response).to redirect_to(welcome_path)
        expect(flash[:alert]).to eq('You do not have permission to access this page.')
      end
    end
  end

  describe 'POST #create' do
    before do
      mock_user_sign_in
    end

    let(:valid_attributes) do
      {
        email: 'admin@tamu.edu',
        uin: '123456',
        first_name: 'John',
        last_name: 'Doe'
      }
    end

    let(:invalid_attributes) do
      {
        email: '',
        uin: '',
        first_name: '',
        last_name: ''
      }
    end

    context 'with valid attributes' do
      it 'creates a new Admin' do
        expect {
          post :create, params: { admin: valid_attributes }
        }.to change(Admin, :count).by(1)
      end

      it 'redirects to the new admin' do
        post :create, params: { admin: valid_attributes }
        expect(response).to redirect_to(Admin.last)
        expect(flash[:notice]).to eq('Admin was successfully created.')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new Admin' do
        expect {
          post :create, params: { admin: invalid_attributes }
          }.to change(Admin, :count).by(0)
      end

      it 'renders the new template' do
        post :create, params: { admin: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH/PUT #update' do
    before do
      mock_user_sign_in
    end

    let(:valid_attributes) do
      {
        email: 'updated_admin@tamu.edu',
        uin: '654321',
        first_name: 'Jane',
        last_name: 'Smith'
      }
    end

    let(:invalid_attributes) do
      {
        email: '',  # Invalid email
        uin: '',
        first_name: '',
        last_name: ''
      }
    end

    context 'with valid attributes' do
      it 'updates the requested admin' do
        admin = Admin.create(email: 'admin@tamu.edu', uin: '123456', first_name: 'John', last_name: 'Doe')
        patch :update, params: { id: admin.id, admin: valid_attributes }
        admin.reload
        expect(admin.email).to eq('updated_admin@tamu.edu')
      end

      it 'redirects to the updated admin' do
        admin = Admin.create(email: 'admin@tamu.edu', uin: '123456', first_name: 'John', last_name: 'Doe')
        patch :update, params: { id: admin.id, admin: valid_attributes }
        expect(response).to redirect_to(admin)
        expect(flash[:notice]).to eq('Admin was successfully updated.')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the admin' do
        admin = Admin.create(email: 'admin@tamu.edu', uin: '123456', first_name: 'John', last_name: 'Doe')
        patch :update, params: { id: admin.id, admin: invalid_attributes }
        admin.reload
        expect(admin.email).to eq('admin@tamu.edu')  # Ensure the email hasn't changed
      end

      it 'renders the edit template' do
        admin = Admin.create(email: 'admin@tamu.edu', uin: '123456', first_name: 'John', last_name: 'Doe')
        patch :update, params: { id: admin.id, admin: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      mock_user_sign_in
    end

    context 'with a valid admin id' do
      it 'destroys the requested admin' do
        admin = Admin.create(email: 'admin@tamu.edu', uin: '123456', first_name: 'John', last_name: 'Doe')
        expect {
          delete :destroy, params: { id: admin.id }
        }.to change(Admin, :count).by(-1)
      end

      it 'redirects to the admins list' do
        admin = Admin.create(email: 'admin@tamu.edu', uin: '123456', first_name: 'John', last_name: 'Doe')
        delete :destroy, params: { id: admin.id }
        expect(response).to redirect_to(admins_path)
        expect(flash[:notice]).to eq('Admin was successfully destroyed.')
      end
    end

    context 'with an invalid admin id' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          delete :destroy, params: { id: -1 } # Assuming 9999 does not exist
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET #new' do
  before do
    mock_user_sign_in
  end
    it 'initializes a new Admin' do
      get :new
      expect(assigns(:admin)).to be_a_new(Admin)
      end
  end

  describe 'GET #index' do
    before do
      mock_user_sign_in
    end

    let!(:admin1) { Admin.create(email: 'admin1@tamu.edu', uin: '123456', first_name: 'John', last_name: 'Doe') }
    let!(:admin2) { Admin.create(email: 'admin2@tamu.edu', uin: '654321', first_name: 'Jane', last_name: 'Smith') }

    it 'assigns all admins to @admins' do
      get :index
      expect(assigns(:admins)).to include(admin1)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:success)
    end
  end
end
