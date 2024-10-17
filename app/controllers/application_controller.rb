class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  before_action :require_login

  private

  def current_logged_in_admin
    # if @current _user is undefined or falsy, evaluate the RHS
    #   RHS := look up user by id only if user id is in the session hash
    # question: what happens if session has user_id but DB does not?
    @current_logged_in_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
  end

  def logged_in?
    # current_user returns @current_user,
    #   which is not nil (truthy) only if session[:user_id] is a valid user id
    current_logged_in_admin
  end

  def require_login
    # redirect to the login page unless user is logged in
    unless logged_in?
      redirect_to login_path, alert: "You must be logged in to access this section."
    end
  end
end
