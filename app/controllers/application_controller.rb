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
    if session[:visitor_cart]
      session[:visitor_cart].each do |add_id, add_quantity|

        if product_exists?(cart, add_id.to_i)
          cart.update_quantity(add_id.to_i, add_quantity)
          #cart.order_contents.where(:product_id => add_id.to_i).first.increase_quantity(add_quantity)
        else
          product = Product.find(add_id)
          cart.products << product
        end

        cart.save!

      end

      session.delete(:visitor_cart)

    end

  end

  private

  def product_exists?(order, product_id)

    # pluck returns an array of attribute values type-casted to match the plucked column names
    # e.g. [1, 2, 3] for product_id
    order.products.pluck(:product_id).include?(product_id)

  end

end
