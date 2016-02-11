class OrdersController < ApplicationController

  def new
    @order = Order.new
  end


  def create
    @order = Order.new(whitelisted_order_params)
    @order.checkout_date ||= Time.now
    if @order.save
      flash[:success] = "Order successfully created"
      redirect_to admin_user_order_path(@order.user, @order)
    else
      flash[:error] = "Order was not created"
      render :new
    end
  end



  def whitelisted_order_params
    params.require(:order).permit(:checkout_date, :user_id, :shipping_id, :billing_id, :credit_card_id)
  end




end
