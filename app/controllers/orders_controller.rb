class OrdersController < ApplicationController

  layout 'portal'


  def index
    @orders = Order.get_index_data(params[:user_id])

    begin
      @filtered_user = User.find(params[:user_id]) if params[:user_id]
    rescue
      flash[:danger] = "User not found.  Redirecting to Orders Index."
      redirect_to orders_path
    end

  end


  def show
    @order = Order.find(params[:id])
    @user = @order.user
    @order_status = @order.define_status
    @shipping_address = @order.shipping_address.build_address_display_hash
    @billing_address = @order.billing_address.build_address_display_hash
    @card = @order.get_card_last_4
    @order_contents = @order.build_contents_table_data
  end


  def new
    @order = Order.new
    @user = User.find(params[:user_id])
    @available_addresses = @user.created_addresses
    @available_cards = @user.credit_cards.all
  end


  def create
    @order = Order.new(order_params)

    if @order.save
      flash[:success] = "Order successfully created!"
      redirect_to edit_order_path(@order.id)
    else
      flash.now[:danger] = "Order not saved - please try again."
      @user = User.find(params[:user_id])
      @available_addresses = @user.created_addresses
      @available_cards = @user.credit_cards.all
      render :new
    end

  end


  def edit
    @order = Order.find(params[:id])
    reset_order_instance_variables
  end


  def update
    @order = Order.find(params[:id])

    #update_info
    if params[:commit] == 'Update Order Information'
      params[:order][:checkout_date] = @order.update_checkout_date(params[:status])

      if @order.update(order_params)
        flash[:success] = "Order successfully updated!"
        redirect_to @order
      else
        flash.now[:danger] = "Order not saved - please try again."
        reset_order_instance_variables
        render :edit
      end
    end


    #update_contents
    if params[:commit] == 'Update Order Contents'
      #update quantity for order/product id combo
      @order_contents = @order.order_contents

      @order_contents.each do |content_row|
        new_quantity = params[content_row.id.to_s].to_i
        # delete if zero
        content_row.update(:quantity => new_quantity)
      end

      redirect_to @order

      #@order_content_row = OrderContents.find(params[:id])

      #if @order_content_row.update(content_params)
      #  flash[:success] = "Order successfully updated!"
       # redirect_to @order
      #else
      #  flash.now[:danger] = "Order not saved - please try again."
      #  reset_order_instance_variables
      #  render :edit
      #end
    end

    #add_products
  end


  def destroy
    @order = Order.find(params[:id])

    if @order.destroy
      flash[:success] = "Order deleted!"
      redirect_to user_path(@order.user_id)
    else
      flash[:danger] = "Delete failed - please try again."
      redirect_to :back
    end

  end


  private


  def reset_order_instance_variables
    @status = @order.define_status
    @user = User.find(@order.user_id)
    @available_addresses = @user.created_addresses
    @available_cards = @user.credit_cards.all
    @order_contents = @order.build_contents_table_data
  end


  def order_params
    params.require(:order).permit(:checkout_date, :shipping_id, :billing_id, :billing_card_id, :user_id)
  end


  def content_params
    params.require(:order_content).permit(:quantity)
  end

end
