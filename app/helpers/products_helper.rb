module ProductsHelper

  # Add first product
  def add_product(product_id)

    if signed_in_user?

      # locate or build a new cart (within user model)
      @current_user.orders.build unless @current_user.has_cart?

      # add a product to the cart
      @current_user.get_cart.products << Product.find(product_id)

    else
      session[:product_id] = product_id
    end

  end

end