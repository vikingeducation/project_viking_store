class OrdersController < ApplicationController
  layout "admin"


  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
        @orders = Order.where(user_id: @user.id)
      else
        flash[:error] = "Invalid user id"
        redirect_to orders_path
      end
    else
      @orders = Order.all
    end
  end

  def new
    @order = Order.new(user_id: params[:user_id])
  end

  def create
    @order = Order.new(whitelisted_order_params)
    @order.checkout_date ||= Time.now
    if @order.save
      flash[:success] = "Order successfully created"
      redirect_to user_order_path(@order.user, @order)
    else
      flash[:error] = "Order was not created"
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
    @user = @order.user
  end

  def update
    @order = Order.find(params[:id])
    @user = @order.user
    @order.checkout_date ||= Time.now if params[:order][:checked_out]
    if @order.update(whitelisted_order_params)
      flash[:success] = "Order successfully updated"
      redirect_to user_order_path(@order.user, @order)
    else
      flash[:error] = "Order was not updated"
      render :edit
    end
  end

  def show
    @order = Order.find(params[:id])
    @user = @order.user
  end


  def destroy
    @order = Order.find(params[:id])    
    if @order.destroy
      flash[:success] = "Order successfully deleted"
    else
      flash[:error] = "Order was not deleted"
    end
    redirect_to orders_path
  end





  def whitelisted_order_params
    params.require(:order).permit(:checkout_date, :user_id, :shipping_id, :billing_id, :credit_card_id)
  end


end
