module ProductsHelper
  def cart_helper(product)
    cart = session[:cart]
    if count = cart.find{|value| value["product_id"].to_i == product.id}
      render partial: "in_cart_btn", locals: {product: product, quantity: count["quantity"].to_i}
    else
      render partial: "add_to_cart_btn", locals: {product: product}
    end
  end
end
