class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find_by(:id => params[:id])
    unless @order
      flash[:danger] = ["Order is not found"]
      redirect_to orders_path
    end
  end

  def new
    user = User.find(params[:user_id])
    unless user.credit_cards.empty?
      @order = Order.new(:user_id => params[:user_id])
    else
      flash[:danger] = ["You can't place order without credit cards!"]
      redirect_to user_path(params[:user_id])
    end
  end

  def create
    @order = Order.new(white_list_params)
    user = User.find_by(:id => params[:order][:user_id])
    if user.has_unplaced_order?
      flash[:danger] = ["you have unplaced order!"]
      redirect_to user_path(user)
    elsif @order.save
      flash[:success] = ["Order has been successfully procceeded!"]
      redirect_to edit_order_path(@order)
    else
      flash.now[:danger] = @order.errors.full_messages
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    user = User.find_by(:id => params[:order][:user_id])
    @order = Order.find(params[:id])
    if !params[:placed] && user.has_additional_unplaced_order?(@order)
      flash.now[:danger] = ["Update failed! You have another unplaced order!"]
      render :edit
    elsif params[:placed] && !@order.checked
      @order[:checkout_date] = Time.now
      if @order.save && @order.update(white_list_params)
        flash[:success] = ["Update success!"]
        redirect_to order_path(@order)
      else
        flash[:danger] = @order.errors.full_messages
        redirect_to order_path(@order_path)
      end
    elsif !params[:placed] && !user.has_additional_unplaced_order?(@order)
      @order[:checkout_date] = nil
      if @order.save && @order.update(white_list_params)
        flash[:success] = ["Update success!"]
        redirect_to order_path(@order)
      else
        flash[:danger] = @order.errors.full_messages
        redirect_to order_path(@order_path)
      end
    else
      flash[:danger] = ["Something wrong!"]
      redirect_to order_path(@order_path)
    end
  end

  private
    def white_list_params
      params.require(:order).permit(:user_id, :shipping_id, :billing_id, :shipping_id, :credit_card_id)
    end

end
