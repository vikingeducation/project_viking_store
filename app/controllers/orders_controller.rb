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


  def create
    @order = Order.new(order_params)

    if @order.save
      flash[:success] = "Order successfully created!"
      redirect_to edit_order_path(@order.id)
    else
      flash.now[:danger] = "Order not saved - please try again."
      @user = User.find(params[:user_id])
      @available_addresses = @user.created_addresses
      @available_cards = @user.credit_cards.all
      render :new
    end

  end


  def edit
    @order = Order.find(params[:id])
    @user = User.find(@order.user_id)
    @available_addresses = @user.created_addresses
    @available_cards = @user.credit_cards.all
  end


=begin
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = "User successfully updated!"
      redirect_to users_path
    else
      flash.now[:danger] = "User not saved - please try again."
      @available_addresses = @user.created_addresses
      render :edit
    end
  end


  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      flash[:success] = "User deleted!"
      redirect_to users_path
    else
      flash[:danger] = "Delete failed - please try again."
      redirect_to :back
    end

  end
=end


  private


  def order_params
    params.require(:order).permit(:shipping_id, :billing_id, :billing_card_id, :user_id)
  end

end
