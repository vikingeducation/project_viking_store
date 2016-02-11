class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #### User Sign-in/Sign-out ####

  def sign_in(user)
    session[:current_user_id] = user.id
    @current_user = user
  end

  def sign_out
    session.delete(:current_user_id)
    @current_user = nil
    session[:current_user_id].nil? && current_user.nil?
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

  #### Shopping Cart ####

  def current_order
    if session[:order_id].nil?
      order = Order.create
      session[:order_id] = order.id
    end
    Order.find(session[:order_id])
  end
end
