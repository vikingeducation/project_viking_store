class UserOrdersController < ApplicationController
  def index
    @user = User.find_by(:id => params[:user_id])
    if @user
      @orders = Order.user_orders(params[:user_id])
    else
      flash[:danger] = ["No such user!"]
      redirect_to orders_path
    end
  end


  def update
    @order = Order.find(params[:id])
    if new_order = OrderContent.update(update_products_params.keys, update_products_params.values)
      flash[:success] = ["Order Contents updated!"]
      redirect_to order_path(@order)
    else
      flash.now[:danger] = new_order.errors.full_messages
      render 'orders#edit'
    end
  end

  private
    def update_products_params
      params.require(:products)
    end

end
