class OrdersController < ApplicationController
  def index
    if params[:user_id]
      @user = User.find(params[:user_id]) 
      @orders = Order.where("user_id=?", params[:user_id]).limit(100)
    else
      #not going to put a flash error because sometimes you just want to see
      #all the orders regardless of user
      @orders = Order.all.limit(100)
    end
  end

  def show
    @order = Order.find(params[:id])
    @shipping_address = @order.shipping_address 
    @billing_address = @order.billing_address
    @order_contents = @order.order_contents
  end

  def new
    @order = Order.new(user_id: params[:user_id])
    @user = User.find(params[:user_id])
  end

  def create
    @order = Order.new(whitelisted_params)
    if @order.save
      flash[:success] = "Order created successfully"
      redirect_to edit_order_path(@order.id)
    else
      flash[:error] = "Something went wrong creating your order"
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
  end
  

  private

  def whitelisted_params
    params.require(:order).permit(:checkout_date, 
                                  :user_id, 
                                  :billing_id, 
                                  :shipping_id)
  end
end
