class  Admin::OrdersController < ApplicationController

  def index
    @user = User.find_by(id: params[:user_id])
    @orders = params[:user_id] ? render_user(params[:user_id]) : render_all
    # @addresses = params[:user_id] ? render_user(params[:user_id]) : render_all
  end

  def new
    @order = Order.new
    @order.user = User.find(params[:user_id])
  end

  def create
    @order = Order.new(white_listed_order_params)
    if @order.save
      flash[:success] = "Order is created."
      redirect_to edit_order_path(@order.id)
    else
      flash.now[:danger] = get_error_message("create", @order)
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(white_listed_order_params)
      flash[:success] = "Order is updated."
      redirect_to order_path(@order)
    else
      flash.now[:danger] = get_error_message("update", @order)
      render :edit
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = "Order is deleted."
      redirect_to orders_path
    else
      flash.now[:danger] = "Not able to delete the order."
      render @order
    end
  end

  private

    def get_error_message(action, object_with_errors)
      "Not able to #{action} the order. REASON: #{
      object_with_errors.errors.full_messages.first}"
    end

    def render_all
      Order.all.limit(100)
    end

    def render_user(user_id)
      orders = Order.where("user_id = #{user_id}")
      if orders.empty?
        flash[:notice] = "User not found."
        return render_all
      else
        return orders.limit(100)
      end
    end

    def white_listed_order_params
      params.require(:order).permit(:user_id, :shipping_id, :billing_id, :checkout_date)
    end

end
