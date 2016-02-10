class OrdersController < ApplicationController

  def index
  end

  def create
    @order = current_user.cart
    @order.order_contents.destroy_all

    session[:cart].each do |product_id, quantity|
      @order.order_contents.build(product_id: product_id, quantity: quantity)
    end

    if @order.save!
      flash[:success] = 'Order created'
      redirect_to order_path(@order)
    else
      flash[:error] = 'Failed to create order'
      redirect_to cart_path(0)
    end
  end

end
