class Admin::OrdersController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @orders = @user.orders
  end

  def new
    @user = User.find(params[:user_id])
    @order = Order.new
  end

  def create
    @user = User.find(params[:user_id])
    @order = Order.new(whitelisted_params)
    @order.user_id = @user.id
    if @order.save
      flash[:success] = 'Order created.'
      redirect_to admin_user_order_path(@user.id, @order)
    else
      flash.now[:error] = 'Order failed to create.'
      render 'new'
    end
  end

  def show
    @user = User.find(params[:user_id])
    @order = Order.find(params[:id])
  end

  private

  def whitelisted_params
    params.require(:order).permit(:id, :shipping_id, :billing_id)
  end
end