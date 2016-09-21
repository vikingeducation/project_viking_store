class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
        @orders = Order.where(user_id: @user.id)
      else
        flash[:error] = "Invalid User Id"
        redirect_to orders_path
      end
    else
      @orders = Order.all
      @user = nil
    end
  end

  def show
    @user = @order.user
    @order_value = Order.order_value(@order.id).values.first
    @num_products = Order.first.order_contents.count
  end

  def new
    @user = User.find(params[:user_id])
    @order = Order.new(user_id: params[:user_id])
    @addresses = []
    @user.addresses.each do |address|
      @addresses << ["#{address[:street_address]}, #{address.city[:name]}, #{address.state[:name]}",
                      address[:id]]
    end

    @credit_cards = []
    @user.credit_cards.each do |cc|
      @credit_cards << ["Card ending in #{cc.last_4}", cc[:id]]
    end
  end

  def create
    order = Order.new(whitelisted_order_params)
    if order.save
      flash[:success] = "order created successfully."
      redirect_to edit_user_order_path(order.user_id, order)
    else
      flash.now[:error] = "Failed to create Address."
      render 'new'
    end
  end

  def edit
    @user = @order.user
    @addresses = []
    @user.addresses.each do |address|
      @addresses << ["#{address[:street_address]}, #{address.city[:name]}, #{address.state[:name]}",
                      address[:id]]
    end

    @credit_cards = []
    @user.credit_cards.each do |cc|
      @credit_cards << ["Card ending in #{cc.last_4}", cc[:id]]
    end
    @order_contents = @order.order_contents
    @order_content = OrderContent.new
  end

  def update
    update_params = whitelisted_order_params
    if params[:placed] == "on"
      update_params["checkout_date"] = DateTime.now.utc
    else
      update_params["checkout_date"] = nil
    end

    if @order.update_attributes(update_params)
      flash[:success] = "order updated successfully."
      redirect_to user_order_path(@order.user_id, @order)
    else
      flash.now[:error] = "Failed to update order."
      render 'edit'
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    if @order.destroy
      flash[:success] = "Order deleted successfully."
      redirect_to user_orders_path(@order.user_id)
    else
      flash[:error] = "Failed to delete Order."
      redirect_to session.delete(:return_to)
    end
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def whitelisted_order_params
    params.require(:order).permit(:checkout_date, :user_id, :shipping_id, :billing_id, :credit_card_id)
  end
end
