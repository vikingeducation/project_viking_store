class OrdersController < ApplicationController
  def index
    if params[:user_id].nil?
      @orders = Order.all
    else
      if User.where(id: params[:user_id]).first.present?
        @user = User.find(params[:user_id])
        @orders = Order.where(user_id: @user.id)
      else
        flash[:error] = "Invalid User Id"
        redirect_to user_orders_path
      end
    end
  end

  def new
    @order = Order.new(user_id: params[:user_id])
    @user = @order.user
  end

  def create
    @order = Order.new(whitelisted_order_params)
    if @order.save
      flash[:success] = "Order created successfully."
      redirect_to edit_user_order_path(@order.user.id, @order.id)
    else
      flash.now[:error] = "Failed to create Order."
      render 'new'
    end
  end

  def show
    @order = Order.find(params[:id])
    @user = @order.user
  end

  def edit
    @order = Order.find(params[:id])
    @user = @order.user
    @purchases = Purchase.where(order_id: @order.id)
  end

  def update
    @order = Order.find(params[:id])
    @order.checkout_date ||= Time.now if params[:order][:checked_out] == "1"
    if @order.update_attributes(whitelisted_order_params)
      flash[:success] = "Order updated successfully."
      redirect_to user_orders_path
    else
      flash.now[:error] = "Failed to update Order."
      render 'edit'
    end
  end

  def destroy
    @order = Order.find(params[:id])
    session[:return_to] ||= request.referer
    if @order.destroy
      flash[:success] = "Order deleted successfully."
      redirect_to user_orders_path
    else
      flash[:error] = "Failed to delete Order."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def whitelisted_order_params
    params.require(:order).permit(:user_id, :billing_id, :shipping_id, :checked_out, :checkout_date, :credit_card_id)
  end
end
