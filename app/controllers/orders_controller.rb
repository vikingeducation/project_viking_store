class OrdersController < ApplicationController
  def index
    @orders = Order.all.order("orders.id")
    @user = params[:user_id].to_i
    if @user != 0
      @user = User.find(@user)
      @orders = @user.orders
    end
  end

  def show
    @order = Order.find(params[:id])
    @user = @order.user
    @order_contents = @order.order_contents
  end
end
