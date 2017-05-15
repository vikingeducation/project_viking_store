class Admin::OrdersController < ApplicationController

  layout 'admin_portal_layout'

  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @orders = Order.where(:user_id => params[:user_id])
      else
        flash[:danger] = "Invalid user ID. We can't display orders for that user."
        redirect_to admin_orders_path
      end
    else
      @orders = Order.all
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @order = Order.new(:user_id => params[:user_id])
  end

  def create
    @order = Order.new(whitelisted_orders_params)
    @order.checkout_date ||= Time.now
    if @order.save
      flash[:success] = "New Order has been created"
      redirect_to edit_admin_order_path(@order.id)
    else
      flash.now[:danger] = "New Order WAS NOT saved. Try again."
      render 'new', :locals => {:order => @order}
    end
  end

  def edit
    @order = Order.find(params[:id])
    @order_contents = OrderContent.where(:order_id => @order.id)
  end

  def update
    # @order = Order.find(params[:id])
    # @order_contents = OrderContent.new(:order_id => @order.id)
    if @order.update_attributes(whitelisted_orders_params)
      flash.now[:success] = "Order has been updated"
      redirect_to admin_order_path
    else
      flash[:danger] = "Order hasn't been saved."
      render 'edit', :locals => {:order => @order}
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = "Order deleted successfully!"
      redirect_to admin_orders_path(:user_id => @order.user)
    else
      flash[:danger] = "Failed to delete the address"
      redirect_to :back
    end
  end

  private
  def whitelisted_orders_params
    params.require(:order).permit(:checkout_date, :user_id, :shipping_id, :billing_id, :credit_card_id)
  end

end
