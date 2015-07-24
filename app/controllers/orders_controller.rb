class OrdersController < ApplicationController

  layout 'portal'


  def index
    @orders = Order.get_index_data(params[:user_id])

    begin
      @filtered_user = User.find(params[:user_id]) if params[:user_id]
    rescue
      flash[:danger] = "User not found.  Redirecting to Orders Index."
      redirect_to orders_path
    end

  end


  def show
    @order = Order.find(params[:id])
    @user = @order.user
    @shipping_address = @order.shipping_address
    @billing_address = @order.billing_address
    @card = nil
  end

end
