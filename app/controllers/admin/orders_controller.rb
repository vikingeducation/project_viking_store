class Admin::OrdersController < AdminController
  layout 'admin'
  def index
    if params[:user_id]
      if User.exists?(:id => params[:user_id])
        @orders = User.find(params[:user_id]).orders.paginate(:page => params[:page])
      else
        @orders = Order.paginate(:page => params[:page])
        flash[:error] = "No such user. Displaying all results instead."
      end
    else
      @orders = Order.paginate(:page => params[:page])
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      flash[:success] = "Order has been created!"
      redirect_to admin_orders_path
    else
      redirect_to new_admin_order_path
    end
  end

  def edit
    @order = Order.find(params[:id])
    @ordercontent = Order.find(params[:id]).order_contents
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      flash[:success] = "Order has been updated!"
      redirect_to admin_order_path(@order, :user_id => @order.user.id)
    else
      redirect_to new_admin_order_path
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = "Order has been destroyed!"
      redirect_to admin_orders_path
    else
      redirect_to new_admin_order_path
    end
  end

  private

  def order_params
    params.require(:order).permit(:checkout_date, :user_id, :shipping_id, :billing_id, :credit_card_id, :order_contents_attributes => [:id, :quantity, :product_id, :_destroy])
  end
end
