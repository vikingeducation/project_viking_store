module ProductsHelper
  def cart_helper(product)
    if session[:cart].any?{|value| value[:product_id] == product.id}
      return "in_cart_btn"
    else
      return "add_to_cart_btn"
    end
  end
end
