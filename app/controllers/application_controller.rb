class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def sign_in(user)
    session[:current_user_id] = user.id
    @current_user = user
  end


  def sign_out
    @current_user = nil
    session.delete(:current_user_id)
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


  def merge_visitor_cart
    cart = current_user.get_or_build_cart

    if session[:visitor_cart]

      session[:visitor_cart].each do |add_id, add_quantity|
        update_quantity(cart, add_id.to_i, add_quantity)
        cart.save!
      end

      session.delete(:visitor_cart)
    end
  end


  private


  def require_login
    unless signed_in_user?
      flash[:error] = "Please sign in before checking out."
      redirect_to new_session_path
    end
  end


  def get_or_build_cart
    if current_user.has_cart?
      current_user.get_cart
    else
      current_user.orders.build
    end
  end


  def update_quantity(cart, product_id, add_quantity)
    if product_exists?(cart, product_id)
      cart.update_quantity(product_id, add_quantity)
    else
      product = Product.find(product_id)
      cart.products << product
    end
  end


  def product_exists?(order, product_id)
    order.products.pluck(:product_id).include?(product_id.to_i)
  end



end
