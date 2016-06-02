class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def signin(user)
    session[:current_user_id] = user.id
    current_user = user
  end

  def signout
    session.delete(:current_user_id)
    current_user = nil
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


  def update_db_cart
    current_user.get_cart? ? (cart = current_user.cart) : (cart = Order.create(:user_id => current_user.id))

    if session[:cart]
      cart.order_contents.destroy_all

      session[:cart].each do |product, quantity|
          cart.order_contents.build( :product_id => product.to_i, 
                                     :quantity => quantity.to_i )
          cart.save
      end
    end
  end

  def update_tmp_cart
    session.delete(:cart)
    session[:cart] = {}
    cart = current_user.cart
    cart.order_contents.each do |content|
      session[:cart][content.product_id] = content.quantity
    end
  end
  
end
