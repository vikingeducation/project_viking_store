class OrdersController < ApplicationController

  def index
    @orders = Order.all
    if params[:user_id] 
      if User.exists?(params[:user_id])
        @orders = Order.where(:user_id => params[:user_id])
        @user = User.find(params[:user_id])
      else
        flash[:warning] = "User could not be found!"
        @orders = Order.all
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
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      flash[:success] = "Success!"
      redirect_to orders_path
    else
      flash.now[:warning] = "Error!"
      render :new
    end
  end

  def edit
    @user = @user = User.find(params[:user_id])
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      flash[:success] = "Success!"
      redirect_to orders_path
    else
      flash.now[:warning] = "Error!"
      render :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = "Success!"
      redirect_to(:back)
    else
      flash[:warning] = "Error!"
      redirect_to(:back)
    end
  end

  private

  def order_params
    require(:order).permit(:user_id, :checkout_date, :shipping_id, :billing_id, :credit_card_id)
  end

end
