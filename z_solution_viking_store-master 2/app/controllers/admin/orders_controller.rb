class Admin::OrdersController < AdminController

  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit]

  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
        @orders = Order.where(user_id: @user.id)
      else
        flash[:error] = "Invalid User Id"
        redirect_to admin_user_orders_path
      end
    else
      @orders = Order.all
    end
  end

  def new
    @user = User.find(params[:user_id])
    @order = @user.orders.build
    3.times { @order.order_contents.build({quantity: nil}) }
  end

  def create
    @order = Order.new(whitelisted_order_params)
    @order.checkout_date ||= Time.now

    if @order.save
      flash[:success] = "Order created successfully."
      redirect_to admin_user_orders_path
    else
      flash.now[:error] = "Failed to create Order."
      render 'new'
    end
  end

  def show
  end

  def edit
    3.times { @order.order_contents.build({quantity: nil}) }
  end

  def update
    @order.checkout_date ||= Time.now if params[:order][:checked_out]
    if @order.update_attributes(whitelisted_order_params)
      flash[:success] = "Order updated successfully."
      redirect_to admin_user_orders_path
    else
      flash.now[:error] = "Failed to update Order."
      render 'edit'
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    if @order.destroy
      flash[:success] = "Order deleted successfully."
      redirect_to admin_user_orders_path
    else
      flash[:error] = "Failed to delete Order."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_user
    @user = @order.user
  end

  def whitelisted_order_params
    params.require(:order).permit(:user_id, :billing_id, :shipping_id, :checkout_date, :credit_card_id, {:order_contents_attributes => [:id, :quantity, :_destroy, :order_id, :product_id]})
  end
end
