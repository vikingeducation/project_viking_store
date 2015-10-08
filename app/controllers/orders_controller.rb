class OrdersController < ApplicationController
  layout 'admin'
  before_action :set_order, :except => [:index]

  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @orders = Order.where('user_id = ?', params[:user_id])
      else
        flash.now[:error] = 'Invalid user'
      end
    end
    @orders = Order.all unless @orders
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @order.update(order_params)
      flash[:success] = 'Order created'
      redirect_to edit_user_order_path(@order.user, @order)
    else
      flash.now[:error] = 'Order not created'
      render :new
    end
  end

  def update
    if @order.update(order_params)
      flash[:success] = 'Order updated'
      redirect_to edit_user_order_path(@order.user, @order)
    else
      flash.now[:error] = 'Order not updated'
      render :edit
    end
  end

  def destroy
    if @order.destroy
      flash[:success] = 'Order deleted'
    else
      flash[:error] = 'Order not deleted, placed orders cannot be deleted'
    end
    redirect_to orders_path
  end


  private
  def set_order
    @order = Order.exists?(params[:id]) ? Order.find(params[:id]) : Order.new
  end

  def order_params
    params.require(:order).permit(
      :checkout_date,
      :user_id,
      :credit_card_id,
      :billing_id,
      :shipping_id
    )
  end
end
