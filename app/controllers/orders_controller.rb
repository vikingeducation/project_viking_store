class OrdersController < ApplicationController

  def index
    @user = User.find_by(id: params[:user_id])
    @orders = params[:user_id] ? render_user(params[:user_id]) : render_all
    # @addresses = params[:user_id] ? render_user(params[:user_id]) : render_all
  end

  def new
    @order = Order.new
    @order.user = User.find(params[:user_id])
  end

  def create
    @order = Order.new(white_listed_order_params)
    if @order.save
      flash[:success] = "Order is created."
      redirect_to edit_order_path(@order.id)
    else
      flash.now[:danger] = "Not able to create the order."
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(white_listed_order_params)
      flash[:success] = "Order is updated."
      redirect_to order_path(@order)
    else
      flash.now[:danger] = "Not able to update the order."
      render :edit
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    # @address = Address.find(params[:id])
    # user_id = @address.user_id if @address
    # if @address.destroy
    #   flash[:success] = "Address is destroyed."
    #   redirect_to addresses_path(user_id: user_id)
    # else
    #   flash[:danger] = "Not able to destroy the address."
    #   redirect_to @address
    # end
  end

  private

    def render_all
      Order.all
    end

    def render_user(user_id)
      orders = Order.where("user_id = #{user_id}")
      if orders.empty?
        flash[:notice] = "User not found."
        return Order.all
      else
        return orders
      end
    end

    def white_listed_order_params
      params.require(:order).permit(:user_id, :shipping_id, :billing_id, :checkout_date)
    end

end
