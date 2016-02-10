class CartsController < ApplicationController
  def show
    if !!params[:add_to_cart]
      current_order.products << Product.find(params[:add_to_cart][:product_id])
    end

    @order_products = current_order.products
  end
end
