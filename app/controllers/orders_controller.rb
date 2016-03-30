class OrdersController < ApplicationController
  before_action :restrict_to_signed_in,
                :set_order

  def new
    redirect_to root_path, :flash => {:error => 'Cannot checkout with empty cart'} if @order.items.empty?
  end

  def create
    if @order.update(order_params)
      create_new_cart
      flash[:success] = 'Order checked out successfully'
      redirect_to root_path
    else
      flash.now[:error] = 'Order not checked out'
      render :new
    end
  end

  def destroy
    if @order.destroy
      create_new_cart
      flash[:success] = 'Order deleted'
    else
      flash[:error] = 'Order not deleted'
    end
    redirect_to root_path
  end


  private
  def assert_id
    # no ID needed
  end

  def set_order
    @order = current_user ? current_user.cart : Order.new
  end

  def order_params
    params.require(:order)
      .permit(
        :checkout_date
      )
  end

  def create_new_cart
    current_user.cart.save # save new cart
  end
end
