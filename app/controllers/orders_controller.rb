class OrdersController < ApplicationController
  def index
    if params[:user_id]
      @user = User.find(params[:user_id]) 
      @orders = Order.where("user_id=?", params[:user_id]).limit(100)
    else
      #not going to put a flash error because sometimes you just want to see
      #all the orders regardless of user
      @orders = Order.all.limit(100)
    end
  end

  def show
  end

  def new
  end

  def edit
  end
end
