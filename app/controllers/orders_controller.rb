class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
        @orders = Order.where(user_id: @user.id)
      else
        flash[:error] = "Invalid User Id"
        redirect_to orders_path
      end
    else
      @orders = Order.all
      @user = nil
    end
  end

  def show
    @user = @order.user
    @order_value = Order.order_value(@order.id).values.first
    @num_products = Order.first.order_contents.count
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def whitelisted_address_params
    params.require(:order).permit(:checkout_date, :user_id, :shipping_id, :billing_id, :credit_card_id)
  end
end
