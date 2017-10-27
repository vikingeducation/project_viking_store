class Admin::OrdersController < ApplicationController

  layout 'admin_portal_layout'

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end


  def create
    @order = Order.new(whitelisted_params)
    if @order.save
      redirect_to admin_order_path(@order)
    else
      render :new
    end
  end


  def edit
    set_order
  end


  def show
    set_order
  end


  def update
    set_order
    if @order.update(whitelisted_params)
      redirect_to admin_order_path(@order)
    else
      render :edit
    end
  end


  def destroy
    set_order
    @order.destroy
    redirect_to admin_orders_path
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def whitelisted_params
    params.require(:order).permit(:user_id, :shipping_id, :billing_id, :checkout_date, :credit_card_id)
  end


end
