class Admin::OrdersController < AdminController
  def index
    @orders = Order.all_order_totals
  end

  def new
    @user = User.find(params[:user_id])
    @order = Order.new
  end

  def create
    @user = User.find(params[:user_id])
    @order = Order.new(order_params)
    @order.user_id = @user.id
    if @order.save
      flash[:success] = "You've Sucessfully Created an Order!"
      redirect_to edit_admin_user_order_path(@user,@order)
    else
      flash.now[:error] = "Error! Order wasn't created!"
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
    @user = @order.user
    @order_info = Order.all_order_totals(@user.id)
  end

  def edit
    @user = User.find(params[:user_id])
    @order = Order.find(params[:id])
    #@order_info = Order.get_detailed_user_info(@order)
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      flash[:success] = "You've Sucessfully Updated the Order!"
      redirect_to admin_order_path(@user)
    else
      flash.now[:error] = "Error! Order wasn't updated!"
      render :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = "You've Sucessfully Deleted the Order!"
      redirect_to [:admin, orders_path]
    else
      flash.now[:error] = "Error! Order wasn't deleted!"
      render :show
    end
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :checkout_date, :credit_card_id, :shipping_id, :billing_id)
  end

end
