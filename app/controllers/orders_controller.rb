class OrdersController < ApplicationController

  def index
  end

  def create
    @order = current_user.cart

    if @order.save
      flash[:success] = 'Order created'
      redirect_to edit_order_path(@order)
    else
      flash[:error] = 'Failed to create order'
      redirect_to cart_path
    end
  end

  def edit
    @order = current_user.cart
  end

  def update
    current_user.cart.checkout_date = Time.now
    @order = current_user.cart

    if @order.update(whitelisted_params)
      flash[:success] = 'Order placed'
      redirect_to products_path
    else
      flash.now[:error] = 'Order failed to place'
      render 'edit'
    end
  end

  private

  def whitelisted_params
    params.require(:order).permit(:id, :shipping_id, :billing_id)
  end

end
