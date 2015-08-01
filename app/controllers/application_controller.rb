class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sign_in(user)
    session[:current_user_id] = user.id
    current_user = user
  end

  # "sign out" by removing the ID and deleting the current_user
  def sign_out
    current_user = nil
    return session.delete(:current_user_id)
  end

  def current_user
    return nil unless session[:current_user_id]
    @current_user ||= User.find(session[:current_user_id])
  end
  helper_method :current_user

  def current_user=(user)
    @current_user = user
  end

  def signed_in_user?
    !!current_user
  end
  helper_method :signed_in_user?

  def require_login
    unless signed_in_user?
      flash[:danger] = "You need to be signed in to view this page."
      redirect_to root_path #< if we've defined a custom login path
    end
  end
end
