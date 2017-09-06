class OrdersController < ApplicationController
  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
        @orders = Order.where(user_id: params[:user_id])
      else
        flash.now[:error] = "Invalid User ID provided. Displaying all Orders."
        @orders = Order.all
      end
    else
      @orders = Order.all
    end

    render layout: "admin_portal"
  end

  def show
    @order = Order.find(params[:id])
    @user = @order.user
    @order_line_items = @order.line_items

    render layout: "admin_portal"
  end

  def new
    if params[:user_id] && User.exists?(params[:user_id])
      @user = User.find(params[:user_id])
      @order = Order.new

      render layout: "admin_portal"
    else
      flash[:error] = "Invalid User ID provided. Redirecting you to the Users page."
      redirect_to users_path
    end
  end

  def create
    @user = User.find(params[:order][:user_id])

    if @user.has_shopping_cart?
      flash[:error] = "This User already has a shopping cart. Edit that Order instead of creating a new one."
      redirect_to user_path(@user)
    else
      @order = Order.new(whitelisted_order_params)
      if @order.save
        flash[:success] = "Order successfully created."
        redirect_to user_path(@user)
      else
        flash.now[:error] = "Error creating Order."
        render "new", layout: "admin_portal"
      end
    end
  end

  private

  def whitelisted_order_params
    params.require(:order).permit(:user_id, :shipping_id, :billing_id, :credit_card_id)
  end
end
