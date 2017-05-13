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
    @order_content = OrderContent.new
  end

  def create
    @order = Order.new(whitelisted_orders_params)
    @order.checkout_date ||= Time.now
    if @order.save
      flash[:success] = "New Order has been created"
      redirect_to edit_admin_order_path(@order.id, :user_id => "#{@order.user_id}")
    else
      flash.now[:danger] = "New Order WAS NOT saved. Try again."
      render 'new', :locals => {:order => @order}
    end
  end

  # def edit
  #   @order = Order.find(params[:id])
  # end

  # def update
  #   @order = Order.find(params[:id])
  #   if @order.update_attributes(whitelisted_orders_params)
  #     flash.now[:success] = "Address has been updated"
  #     redirect_to admin_address_path
  #   else
  #     flash[:danger] = "Address hasn't been saved."
  #     render 'edit', :locals => {:order => @order}
  #   end
  # end

  # def destroy
  #   @order = Order.find(params[:id])
  #   if @order.destroy
  #     flash[:success] = "Address deleted successfully!"
  #     redirect_to admin_addresses_path
  #   else
  #     flash[:danger] = "Failed to delete the address"
  #     redirect_to request.referer
  #   end
  # end

  private
  def whitelisted_orders_params
    params.require(:order).permit(:checkout_date, :user_id, :shipping_id, :billing_id, :credit_card_id)
  end

end
