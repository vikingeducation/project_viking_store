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

    if @user.cart?
      order = @user.cart
      redirect_to edit_admin_user_order_path(@user, order)
    else
      @order = @user.orders.new
      3.times { @order.order_contents.build({quantity: nil}) }
    end
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
    if @order.update(order_params)
      flash[:notice] = "Order #{@order.id} has been updated. pew! pew! pew!"
      redirect_to admin_user_order_path(@order.user, @order)
    else
      flash.now[:error] = 'Aw crap. Fix that stuff below.'
      render :edit
    end
  end

  def destroy
    user = User.find(params[:user_id])
    order = user.orders.find(params[:id])

    session[:return_to] ||= request.referer
    if order.destroy
      flash[:notice] = "Order #{order.id} deleted successfully."
      redirect_to admin_user_orders_path(user)
    else
      flash.now[:alert] = "Failed to delete Order #{order.id}."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :checkout_date, :shipping_id, :billing_id, :credit_card_id)
  end

  def set_order
    @order = Order.find(params[:id])
  end

end
