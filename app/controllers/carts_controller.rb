class CartsController < ApplicationController
  def update
    if current_user
      update_database_cart
    else
      update_session_cart
    end
    redirect_to products_path
  end

  private
    def update_session_cart
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

    end

    def update_database_cart
      cart = current_user.cart
      product_id, quantity = params["product_id"], params["quantity"].to_i
      if product = cart.order_contents.find_by(product_id: product_id)
        if quantity == 0
          flash[:notice] = "Product removed from cart."
          product.destroy
        else
          flash[:notice] = "Product Quantity Updated!"
          product.update(quantity: quantity)
        end
      else
        flash[:notice] = "Product Added to Cart!"
        cart.order_contents.create(product_id: product_id, quantity: quantity)
      end
    end
end
