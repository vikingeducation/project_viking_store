class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sign_in(user)
    session[:current_user_id] = user.id
    current_user= user
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


  def require_login
    unless signed_in_user?
      store_location       
      flash[:danger] = "You need to sign in/register!"
      redirect_to signin_path
    end
  end


  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  

  def store_location
    session[:forwarding_url] = request.fullpath if request.get?
  end

  # These methods determine the item count and color of the 
  # Shopping cart button in the navbar.
  def cart_size
    user = current_user
    if session[:cart]
      session[:cart].size
    elsif items_in_cart?(user)
      user.cart.order_contents.size
    end
  end
  helper_method :cart_size


  def items_in_cart?(user)
    user && user.cart && user.cart.products.any?
  end


  def highlight_cart?
    user = current_user
    items_in_cart?(user) && session[:cart]
  end
  helper_method :highlight_cart?


end
