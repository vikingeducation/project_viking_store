module ProductsHelper
  def cart_helper(product)
    if current_user
      cart = current_user.cart
    else
      cart = session[:cart]
    end

    button_for_cart(cart, product)
  end

  def button_for_cart(cart, product)
    if cart.is_a? Array
      if count = cart.find{|value| value["product_id"].to_i == product.id}
        render partial: "in_cart_btn", locals: {product: product, quantity: count["quantity"].to_i}
      else
        render partial: "add_to_cart_btn", locals: {product: product}
      end
    else
      if count = cart.order_contents.find_by(product_id: product.id)
        render partial: "in_cart_btn", locals: {product: product, quantity: count.quantity.to_i}
      else
        render partial: "add_to_cart_btn", locals: {product: product}
      end
    end
  end
end
