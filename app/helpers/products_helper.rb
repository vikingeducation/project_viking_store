module ProductsHelper
  # Generates a button depending on whether the user is logged in or not
  # and if the user already has the product in their cart or not.
  def cart_helper(product)
    if current_user
      button_for_unplaced_user(product)
    else
      button_for_session_cart(product)
    end

  end

  def button_for_session_cart(product)
    cart = session[:cart]
    if count = cart.find{|value| value["product_id"].to_i == product.id}
      render partial: "in_cart_btn", locals: {product: product, quantity: count["quantity"].to_i}
    else
      render partial: "add_to_cart_btn", locals: {product: product}
    end
  end

  def button_for_unplaced_user(product)
    cart = current_user.cart
    if count = cart.order_contents.find_by(product_id: product.id)
      render partial: "in_cart_btn", locals: {product: product, quantity: count.quantity.to_i}
    else
      render partial: "add_to_cart_btn", locals: {product: product}
    end
  end
end
