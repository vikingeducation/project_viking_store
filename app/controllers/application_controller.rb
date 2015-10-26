class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sign_in(user)

    session[:current_user_id] = user.id
    @current_user = user
    merge_visiter_cart

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

  def merge_visiter_cart

    cart = current_user.get_or_build_cart

    if session[:visiter_cart]

      session[:visiter_cart].each do |add_id, add_quantity|
        update_quantity(cart, add_id.to_i, add_quantity)
        cart.save!
      end

      session.delete(:visiter_cart)
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
      # order model
      cart.update_quantity(product_id, add_quantity)
    else
      # adds product to cart if product_id is not already in cart
      product = Product.find(product_id)
      cart.products << product
    end

  end

  # check if product_id exists in cart
  def product_exists?(order, product_id)

    # pluck returns an array of attribute values type-casted to match the plucked column names
    # e.g. [1, 2, 3] for product_id
    order.products.pluck(:product_id).include?(product_id.to_i)

  end

end
