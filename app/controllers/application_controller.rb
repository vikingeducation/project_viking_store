class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def sign_in(user)
    session[:current_user_id] = user.id
    @current_user = user
  end


  def sign_out
    session.delete(:current_user_id) && @current_user = nil
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
    !!@current_user
  end
  helper_method :signed_in_user?


  def merge_visitor_cart
    if current_user.has_cart?
      cart = current_user.get_cart
    else
      cart = current_user.orders.build
    end

    # run through session[:visitor_cart] and add qty based on id's
    session[:visitor_cart].each do |add_id, add_quantity|

      if cart.products.pluck(:product_id).include?(add_id.to_i)
        cart.order_contents.where(:product_id => add_id.to_i).increase_quantity(add_quantity) # not saving?
        # cart.order_contents.increase_quantity(add_quantity)
      else
        product = Product.find(add_id)
        cart.products << product
      end

      cart.save!

    end

    # clear visitor_cart
    session.delete(:visitor_cart)

  end

end
