class OrdersController < ApplicationController
  def index
    if params[:user_id]
      @user = User.find(params[:user_id]) 
      @orders = Order.where("user_id=?", params[:user_id]).limit(100)
    else
      #not going to put a flash error because sometimes you just want to see
      #all the orders regardless of user
      @orders = Order.all.limit(100)
    end
  end

  def show
    @order = Order.find(params[:id])
    @shipping_address = @order.shipping_address 
    @billing_address = @order.billing_address
    @order_contents = @order.order_contents
  end

  def new
    @order = Order.new(user_id: params[:user_id])
    @user = User.find(params[:user_id])
  end

  def create
    @order = Order.new(whitelisted_params)
    if @order.save
      flash[:success] = "Order created successfully"
      redirect_to edit_order_path(@order.id)
    else
      flash[:error] = "Something went wrong creating your order"
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
    @user = User.find(@order.user.id)
    5.times { @order.order_contents.build({quantity: nil}) }
  end

  def update
    @order = Order.find(params[:id])
    @order.checkout_date ||= Time.now if params[:order][:checked_out?]
    if @order.update_attributes(whitelisted_params)
      flash[:success] = "Order successfully updated"
      redirect_to order_path(@order.id)
    else 
      flash[:error] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = "Order successfully destroyed"
      redirect_to orders_path
    else
      flash[:error] = "Something went wrong"
      redirect_to :back
    end
  end
  

  private

  def whitelisted_params
    params.require(:order).permit(:checkout_date, 
                                  :user_id, 
                                  :billing_id, 
                                  :shipping_id,
                                  :credit_card_id,
                                  {:order_contents_attributes => 
                                    [:id, :quantity, :_destroy, :order_id, 
                                      :product_id]
                                  })
  end
end
