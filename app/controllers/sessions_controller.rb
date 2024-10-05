class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :omniauth ]

  # GET /logout
  def logout
    reset_session
    redirect_to login_path, notice: "You are logged out."
  end

  def omniauth
  end

  # GET /auth/google_oauth2/callback
  def omniauth
    auth = request.env["omniauth.auth"]["info"]
    @admin = Admin.find_by(email: auth["email"]) do |a|
      a.email = auth["email"]
      a.first_name = auth["first_name"]
      a.last_name = auth["last_name"]
    end

    if @admin&.valid?
      session[:admin_id] = @admin.id
      flash[:notice] = "You are logged in."
      redirect_to welcome_path
    else
      flash[:notice] = "Login failed."
      redirect_to login_path
    end
  end
end
