class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sign_in(user)
    session[:current_user_id] = user.id
    current_user = user
  end

  def sign_out
    session.delete(:current_user_id)
    current_user = nil
    session[:current_user_id].nil? && current_user.nil?
  end

  def current_user
    return nil unless session[:current_user_id]
    return nil unless User.find(session[:current_user_id])
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

  private

  def require_login
    unless signed_in_user?
      flash[:error] = 'You need to sign in to view this content.'
      redirect_to new_session_path
    end
  end
end
