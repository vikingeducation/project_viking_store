class Admin::OrdersController < AdminController
  layout "admin"

  def index
    @orders = Order.user_order(params[:user_id])
  end

  def new
    @order = Order.new
    @user = User.find(params[:user_id])
  end

  def create
    @order = Order.new(whitelisted_order_params)
    if @order.save
      flash[:success] = "Empty order created!"
      redirect_to edit_admin_order_path(@order.id)
    else
      flash[:error] = @order.errors.full_messages.to_sentence
      render "/admin/orders/new"
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(whitelisted_order_status_params)
      flash[:success] = "Order status updated!"
      redirect_to admin_order_path(@order.id)
    else
      flash[:error] = @order.errors.full_messages.to_sentence
      render "/admin/orders/edit"
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def show
    @order = Order.find(params[:id])
  end

  def whitelisted_order_params
    params.require(:order).permit(:user_id, :shipping_id, :billing_id)
  end

  def whitelisted_order_status_params
    params.require(:order).permit(:checkout_date)
  end
end
