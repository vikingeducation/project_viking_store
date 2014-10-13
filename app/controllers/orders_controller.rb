class OrdersController < ApplicationController

  def index
    if (params[:user_id] != nil)
      confirm_user_id
    else
      @orders = Order.all
    end
    render :layout => "admin_interface"
  end

  def edit
    @order = Order.find(params[:id])
    @user=@order.user
  end

  def new
    @user = User.find(params[:user_id])
    @addresses = get_valid_addresses
    @order = Order.new
    render :layout => "admin_interface"
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      flash[:success] = "Order #{@order.id} has been successfully created!"
      redirect_to edit_user_order_path(@order.user_id,@order.id)
    else
      flash[:error] = "Order was not created, please try again"
      @user=User.user
      render 'new'
    end
  end

  def update
    fail
    @order = Order.find(params[:id])
      if @order.update(order_params)
        flash[:success] = "Order  \"#{@order.id}\" edited successfully"
        redirect_to @order
      else
        flash[:error] = "Whoops!"
        @user=@order.user
        render 'edit'
      end
  end

  def show
    @order = Order.find(params[:id])
    @ship_address = Address.find(@order.shipping_address_id)
    @bill_address = Address.find(@order.billing_address_id)
    @shipping_street = @ship_address.street_address
    @shipping_city = @ship_address.city
    @shipping_state = @ship_address.state

    @billing_street = @bill_address.street_address  
    @billing_city = @bill_address.city
    @billing_state = @bill_address.state



    render :layout => "admin_interface"
  end

  def destroy

  end

  def edit
    @order = Order.find(params[:id])
    render :layout => "admin_interface"
  end

  def update

  end

# ---- utility methods ----

  private

  def order_params
    params.require(:order).permit(:user_id,:shipping_address_id,:billing_address_id, :is_placed, :placed_at)
  end

  def confirm_user_id
    if Order.where(id: params[:user_id]).empty?
        @orders=Order.all
    else
        @orders=Order.where(user_id: params[:user_id])
        @filtered = true
        @first_name = User.find(params[:user_id]).first_name
        @last_name = User.find(params[:user_id]).last_name
        @user_id = params[:user_id]
    end
  end

  def get_valid_addresses
      Address.where(user_id: @user.id)
  end


end # class
