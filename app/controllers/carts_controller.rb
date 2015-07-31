class CartsController < ApplicationController
  def update
    cart = session[:cart]
    product_id, quantity = params["product_id"], params["quantity"].to_i
    if product = cart.find{|value| value["product_id"] == product_id}
      if quantity == 0
        flash[:notice] = "Product removed from cart."
        cart.delete(product)
      else
        flash[:notice] = "Product Quantity Updated!"
        product[:quantity] = quantity
      end
    else
      flash[:notice] = "Product Added to Cart!"
      cart << {product_id: product_id, quantity: quantity}
    end

    session[:cart] = cart
    redirect_to products_path
  end
end
