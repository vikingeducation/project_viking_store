class Admin::OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to admin_order_path(@order), notice: "Order Created!"
    else
      flash.now[:alert] = "Failed to create order."
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "Order Updated!"
    else
      flash.now[:alert] = "Failed to update order."
      render :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      redirect_to admin_orders_path, notice: "Order Destroyed!"
    else
      redirect_to :back, alert: "Failed to Delete Order."
    end
  end

  private

  def order_params
    params.require(:order).permit(  :checkout_date,
                                    :user_id,
                                    :shipping_id,
                                    :billing_id,
                                    :credit_card_id
    )
  end
end
