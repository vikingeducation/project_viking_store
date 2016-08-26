class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find_by(:id => params[:id])
    unless @order
      flash[:danger] = ["Order is not found"]
      redirect_to orders_path
    end
  end
end
