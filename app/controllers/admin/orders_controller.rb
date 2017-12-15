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
    @user = @order.user
    @qty_products = @order.products.uniq.count
    @card = @order.credit_card
    @items = @order.contents
  end

  def new
    @user = User.find(params[:user_id])
    @order = @user.orders.new
  end

  def create
    user = User.find(params[:user_id])
    order = user.orders.new(order_params)
    if order.save
      flash[:notice] = "Order #{order.id} has been created. Beeeewm."
      redirect_to edit_admin_user_order_path(user, order)
    else
      flash.now[:alert] = "Booooo. Something went wrong."
      render :new
    end

  end

  def edit
    if params[:user_id]
      @user = User.find(params[:user_id])
    end
  end

  def update
  end

  def destroy
    user = User.find(params[:user_id])
    order = user.orders.find(params[:id])
    order.destroy
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :checkout_date, :shipping_id, :billing_id, :credit_card_id)
  end

  def set_order
    @order = Order.find(params[:id])
  end

end
