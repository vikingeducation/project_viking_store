class Admin::OrdersController < AdminController

  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all.limit(100)
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
