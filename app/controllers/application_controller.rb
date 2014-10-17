class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_current_user

  def sign_in(user)
    session[:current_user_id] = user.id
    current_user = user
  end
  
  def sign_out(user)
    session.delete(:current_user_id) && current_user = nil
  end
  
   # returns true/false that user is signed in or not.
   def user_signed_in?
     !!current_user
   end

  def require_login
    unless signed_in_user?
      flash[:error] = "You need to sign in to see this."
      redirect_to login_path
    end
  end

   def current_user
     return nil unless session[:current_user_id]
     @current_user ||= User.find(session[:current_user_id])
   end
   
   def current_user=(user)
     @current_user = user
   end
   
  private

  def check_current_user
    @current_user = current_user
  end

end
