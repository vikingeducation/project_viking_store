module ProductsHelper

  # Add First product
  def add_product(product_id)
    if signed_in_user?
      # locate or build new cart (in User model)
      @current_user.orders.build unless @current_user.has_cart?

      # add one product to cart
      @current_user.get_cart.products << Product.find(product_id)

      # go to cart page
    else
      session[:product_id] = product_id
      # take to sign-in page, storing product ID in session for now
    end
  end



end
