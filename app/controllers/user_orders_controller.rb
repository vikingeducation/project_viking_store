class UserOrdersController < ApplicationController
  def index
    @user = User.find_by(:id => params[:user_id])
    if @user
      @orders = Order.user_orders(params[:user_id])
    else
      flash[:danger] = ["No such user!"]
      redirect_to orders_path
    end
  end
end
