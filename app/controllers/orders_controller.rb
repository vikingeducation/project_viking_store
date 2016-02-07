class OrdersController < ApplicationController
  def index
    @orders = Order.all.order("orders.id")
    @user = params[:user_id].to_i
    if @user != 0
      @user = User.find(@user)
      @orders = @user.orders
    end
  end
end
