class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sign_in(user)
    session[:current_user_id] = user.id
    current_user= user
    merge_cart if session[:cart]
  end


  def sign_out
    session.delete(:current_user_id)
    current_user = nil
    session[:current_user_id].nil? && current_user.nil?
  end


  def current_user
    return nil unless session[:current_user_id]
    @current_user ||= User.find_by_id(session[:current_user_id])
  end
  helper_method :current_user


  def current_user=(user)
    @current_user = user
  end


  def signed_in_user?
    !!current_user
  end
  helper_method :signed_in_user?


  def merge_cart
    user = current_user
    if user.cart
      @cart = user.cart
    else
      @cart = Order.new
    end

    session[:cart].each do |product_id, quantity|
      @cart.order_contents.build(product_id: product_id, quantity: quantity)
    end
    
    if @cart.save
      session.delete(:cart)
    end
  end

end
