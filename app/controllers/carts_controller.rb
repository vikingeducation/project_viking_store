class CartsController < ApplicationController
  def show
    if !!params[:add_to_cart]
      current_order.products << Product.find(params[:add_to_cart][:product_id])
    end
    @order = current_order
    @order_contents = current_order.order_contents
    @products = current_order.products
  end

  # TODO use nested forms to edit orders etc
end
