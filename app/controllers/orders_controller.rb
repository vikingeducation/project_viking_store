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

  def new
    @user = User.find(params[:user_id])
    @order = Order.new
  end

  def create
    @user = User.find(params[:user_id])
    @order = Order.new(whitelisted_params)
    @user.orders << @order
    if @order.save
      redirect_to edit_user_order_path(@user, @order)
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @order = Order.find(params[:id])
    @order.order_contents.build
    @order.order_contents.build
    @order.order_contents.build
  end

  def update

  end

  private

    def whitelisted_params
      params.require(:order).permit(:billing_id, :shipping_id)
    end
end




