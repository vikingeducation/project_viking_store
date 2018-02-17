require 'pry'

class Admin::OrdersController < ApplicationController

  layout 'admin_portal_layout'

  around_action :rescue_from_fk_contraint, only: [:update]

  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @orders = Order.where(:user_id => params[:user_id])
      else
        flash[:danger] = "Invalid user ID. We can't display orders for that user."
        redirect_to admin_orders_path
      end
    else
      @orders = Order.all
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @order = Order.new(:user_id => params[:user_id])
    5.times { @order.order_contents.build(:quantity => nil)}
  end

  def create
    @order = Order.new(whitelisted_orders_params)
    @order.checkout_date ||= Time.now
    if @order.save
      flash[:success] = "New Order has been created"
      redirect_to edit_admin_order_path(@order.id)
    else
      flash.now[:danger] = "New Order WAS NOT saved. Try again."
      render 'new', :locals => {:order => @order}
    end
  end

  def edit
    @order = Order.find(params[:id])
    5.times { @order.order_contents.build(:quantity => nil)}
  end

  def update
    @order = Order.find(params[:id])
    @order.combine_duplicate_products(whitelisted_orders_params) if params[:order][:order_contents_attributes]
    # if eval(params[:order][:checkout_date].to_s) && @order.user.orders.where(:checkout_date => nil).count <= 1
    #   binding.pry
    #     @order.update(:checkout_date => Time.now)
    # end
    if @order.update(whitelisted_orders_params)
      @order.order_contents.where(:quantity => 0).destroy_all
      flash.now[:success] = "Order has been updated"
      redirect_to admin_order_path
    else
      flash[:danger] = "Order hasn't been saved." + @order.errors.full_messages.join(', ')
      render 'edit', :locals => {:order => @order}
    end
  end

  def destroy
    @order = Order.find(params[:id])
    take_user = @order.user_id
    if @order.destroy
      flash[:success] = "Order deleted successfully!"
      redirect_to admin_orders_path, :locals => {:user_id => take_user }
    else
      flash[:danger] = "Failed to delete the address"
      redirect_to :back
    end
  end

  private
  def whitelisted_orders_params
    params.require(:order).permit(:checkout_date, :user_id, :shipping_id, :billing_id, :credit_card_id, 
      {:order_contents_attributes => [:id,
                                :quantity,
                                :product_id,
                                :order_id,
                                :_destroy ] } )
  end

  def rescue_from_fk_contraint
    begin
      yield
    rescue ActiveRecord::InvalidForeignKey
      flash[:danger] = "Order hasn't been saved. Provided invalid Product ID."
      redirect_to :back
    end
  end


end
