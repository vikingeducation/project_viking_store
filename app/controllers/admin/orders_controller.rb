class Admin::OrdersController < ApplicationController

  layout 'admin_portal_layout'

  def index
    unless params[:user_id].nil?
      if User.exists?(params[:user_id])
        @orders = Order.where(user_id: params[:user_id]).includes(:user).limit(100)
        @user = User.find(params[:user_id])
        @user_full_name = @user.full_name
      else
        flash[:danger] = "No User with that ID"
        @orders = Order.all.includes(:user).limit(100)
      end
    else
      @orders = Order.all.includes(:user).limit(100)
    end
  end


  def new
    @user = User.find(params[:user_id])
    @order = @user.orders.build
  end


  def create
    @user = User.find(params[:order][:user_id])
    @order = @user.orders.build(whitelisted_params)
    if @order.save
      flash[:success] = "Order Successfully Created!"
      redirect_to edit_admin_order_path(@order)
    else
      flash[:danger] = "Order NOT Created - See Errors on Form"
      render :new
    end
  end


  def show
    set_order
    @billing_address = Address.find(@order.billing_id)
    @shipping_address = Address.find(@order.shipping_id)
    @credit_card_last_four = last_four_of_cc
    @order_contents = OrderContent.where(order_id: @order.id)
  end


  def edit
    @order = Order.find(params[:id])
    @user = User.find(@order.user_id)
    @order_contents = @order.order_contents
  end


  def update
    set_order
    @user = User.find(@order.user_id)
    if @order.update(whitelisted_params)
      redirect_to admin_order_path(@order)
    else
      render :edit
    end
  end


  def destroy
    set_order
    if @order.destroy
      case request.referer.present?
      when request.referer.include?('/admin/orders')
        flash[:success] = "Order # #{@order.id} Succesfully Deleted"
        redirect_to admin_orders_path
      when request.referer.include?('admin/users')
        flash[:success] = "Order #: #{@order.id} Succesfully Deleted"
        redirect_back(fallback_location: admin_orders_path)
      end
    else
      flash[:danger] = "Order Could NOT Be Deleted"
      redirect_to admin_order_path(@order)
    end
  end


  private


  def set_order
    @order = Order.find(params[:id])
  end


  def whitelisted_params
    params.require(:order).permit(:user_id, :shipping_id, :billing_id, :checkout_date, :credit_card_id, :order_contents_attributes => [:product_id, :quantity, :order_id])
  end



  def last_four_of_cc
    if @order.credit_card_id.nil?
      "N/A"
    else
      @credit_card_last_four = CreditCard.find(@order.credit_card_id).card_number.chars.last(4).join
    end
  end


end
