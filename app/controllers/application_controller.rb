class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def sign_in_user(user)
    session[:current_user_id] = user.id
    @current_user = user
  end

  def current_user
    # eject if we don't have a user in the session
    return nil unless session[:current_user_id]

    # set the user by either:
    # 1. saving the one that was already set in the instance variable
    # 2. pulling from the database based on session
    @current_user ||= User.find(session[:current_user_id])
  end
  helper_method :current_user

  def sign_out
    session.delete(:current_user_id)
    current_user = nil
    session[:current_user_id].nil? && current_user.nil?
  end


  def current_user=(user)
    @current_user = user
  end

  def signed_in_user?
    !!current_user
  end
  helper_method :signed_in_user?



  
end

