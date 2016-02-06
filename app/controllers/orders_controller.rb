class OrdersController < ApplicationController

  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
        @orders = @user.orders
        render :index
      else
        flash.notice = "Improper user id"
        @orders = Order.all
      end
    else
      @orders = Order.all
    end
  end

  def show
    @user = User.find(params[:user_id])
    @order = Order.find(params[:id])
  end
end
