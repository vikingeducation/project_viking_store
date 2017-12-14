class Admin::OrdersController < AdminController

  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @order_limit = 100
    @order_count = Order.count
    if params[:user_id]
      @user = User.find(params[:user_id])
      @orders = @user.orders.limit(@order_limit)
    else
      @orders = Order.all.limit(@order_limit)
    end
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :checkout_date, :shipping_id, :billing_id, :credit_card_id)
  end

  def set_order
    @order = Order.find(params[:id])
  end

end
