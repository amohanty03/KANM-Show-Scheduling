class LoginController < ApplicationController
  skip_before_action :require_login, only: [ :index ]

  def index
    if logged_in?
      redirect_to admin_path(@current_admin), notice: "Welcome, back!"
    end
  end
end
