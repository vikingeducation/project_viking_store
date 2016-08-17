class OrdersController < ApplicationController
  def index
    @user = User.find(params[:user_id]) if params[:user_id]
    @orders = Order.all.limit(100)
  end

  def show
  end

  def new
  end

  def edit
  end
end
