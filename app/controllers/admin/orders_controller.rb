class Admin::OrdersController < AdminController

  def index
    if @user = valid_user
      @orders = @user.orders
    elsif params[:user_id] # user_id there but invalid
      flash[:danger] = "Invalid User!"
      @orders = Order.all.order(:user_id)
    else
      @orders = Order.all.order(:user_id)
    end
  end


  def show
    @order = Order.find(params[:id])
  end


  def new
    if user = valid_user
      @order = user.orders.new
    else
      flash[:danger] = "Order cannot be created without valid User!"
      redirect_to admin_orders_path
    end
  end


  def create
    @order = Order.new(order_params)
    if @order.save
      flash[:success] = "New Order Created!"
      redirect_to edit_admin_order_path(@order)
    else
      flash.now[:danger] = "Oops, something went wrong!"
      render :new
    end
  end


  def edit
    @order = Order.find(params[:id])
    build_blank_order_contents
  end


  def update
    @order = Order.find(params[:id])
    if @order.update(order_params) 
      flash[:success] = "Order Updated!"
      redirect_to admin_order_path(@order)
    else
      flash.now[:danger] = "Oops, something went wrong!"
      build_blank_order_contents
      render :edit
    end
  end  


  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:warning] = "Order ##{@order.id} Deleted!"
      redirect_to admin_orders_path
    else
      flash[:danger] = "Oops, something went wrong!"
      redirect_to :back
    end
  end


  private


  def order_params
    params.require(:order).permit(:shipping_id, :billing_id, :credit_card_id, 
                                  :user_id, :toggle, order_contents_attributes: 
                                  [:quantity, :product_id, :id, :_destroy])
  end


  def build_blank_order_contents
    unsaved_count = @order.order_contents.select(&:new_record?).size
    (5 - unsaved_count).times do
      @order.order_contents.build
    end
  end

end
