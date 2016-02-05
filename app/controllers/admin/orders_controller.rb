class Admin::OrdersController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @orders = @user.orders
  end

  def new
    @user = User.find(params[:user_id])
    @order = Order.new
  end
end