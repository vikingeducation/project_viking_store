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
    @order_status = @order.define_status
    @shipping_address = @order.shipping_address.build_address_display_hash
    @billing_address = @order.billing_address.build_address_display_hash
    @card = @order.get_card_last_4
    @order_contents = @order.build_contents_table_data
  end


  def new
    @order = Order.new
    @user = User.find(params[:user_id])
    @available_addresses = @user.created_addresses
    @available_cards = @user.credit_cards.all
  end

end
