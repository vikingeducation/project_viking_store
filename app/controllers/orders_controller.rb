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
        redirect_to edit_order_path(@order)
      else
        flash.now[:error] = "Error creating Order."
        render "new", layout: "admin_portal"
      end
    end
  end

  def edit
    @order = Order.find(params[:id])
    @user = @order.user
    @line_items = @order.line_items
    @products = Product.all.order(:name)

    render layout: "admin_portal"
  end

  def update
    @user = User.find(params[:order][:user_id])

    @order = Order.find(params[:id])
    order_params = whitelisted_order_params
    order_status = order_params[:checkout_date]

    # check if Order is set to placed or unplaced, and set :checkout_date accordingly
    if order_status == "placed"
      order_params[:checkout_date] = Time.now
    elsif order_status = "unplaced"
      if @user.shopping_cart == @order
        # check if the Order we're setting as unplaced is the User's existing unplaced Order. If so, we allow it to be saved.
        order_params[:checkout_date] = @user.shopping_cart.checkout_date
      elsif @user.has_shopping_cart? && @order != @user.shopping_cart
        # check if we're attempting to create a second unplaced Order for this User
        flash[:error] = "This User already has an unplaced order."
        redirect_to @order and return
      else
        order_params[:checkout_date] = nil
      end
    else
      # raise error here?
    end

    if @order.update(order_params)
      flash[:success] = "Order successfully updated."
      redirect_to @order
    else
      flash[:error] = "Error updating order."
      render "edit", layout: "admin_portal"
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @user = @order.user
    session[:return_to] ||= request.referer

    if @order.destroy
      flash[:success] = "Order successfully removed."
      redirect_to @user
    else
      flash.now[:failure] = "Error removing Order."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def whitelisted_order_params
    params.require(:order).permit(:checkout_date, :user_id, :shipping_id, :billing_id, :credit_card_id)
  end
end
