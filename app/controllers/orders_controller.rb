class OrdersController < ApplicationController

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new(user_id: params[:user_id])
  end

  def create
     @order = Order.new(order_form_params)
    if @order.save
      flash[:success] = "Order created successfully."
      redirect_to user_order_path(@order)
    else
      flash[:error] = "Order not created"
      render :index
    end
  end

  def show
    @order = Order.find(params[:id])
    @address = Address.where(:order_id => @order.id)
  end

  def edit
    @order = Order.find(params[:id])
    @user = @order.user
    @order_contents = @order.order_contents
  end

  def update
     @order = Order.find(params[:id])
    if @order.update_attributes(order_form_params)
    flash[:success] = "Order updated successfully."
    redirect_to user_order_path(@order.user, @order)
    else
      flash[:error] = "Order not updated"
      render :show
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = "Order deleted successfully."
      redirect_to user_orders_path
    else
      flash[:error] = "Order not deleted"
      redirect_to session.delete(:return_to)
    end
  end

  
private
  def order_form_params
    params.require(:order).permit(:checkout_date, :user_id, :shipping_id, :billing_id)
  end
end

