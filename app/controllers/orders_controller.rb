class OrdersController < ApplicationController

  layout 'front_facing'

  def destroy
    Order.find(params[:id]).destroy
    current_user.orders.create
    flash[:notice] = "Order has been destroyed."
    redirect_to root_path
  end

  # First off, I want this to only work if the user is currently signed in and only if the order belongs to the signed_in user... 
  def edit
    # First - making sure that the user is signed in.
    if signed_in_user?
      # Second - making sure the order in the params is that user's shopping cart
      if current_user.orders.where(:checkout_date => nil).first.id == params[:id].to_i
        @order = Order.find(params[:id])
        @order_total = order_total(@order.order_contents)
      else
        flash[:alert] = "You can only checkout your current shopping cart."
        redirect_to shoppingcart_path
      end
    else
      flash[:alert] = "Please sign in or sign up to check out."
      redirect_to new_session_path
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(whitelisted_params)
      flash[:notice] = "Your order has been sent!"
      @order.user.orders.create
      redirect_to root_path
    else
      flash.now[:alert] = "You need to fill out all the fields"
      render :edit
    end
  end

  private

  def whitelisted_params
    params.require(:order).permit(:shipping_id, :billing_id, :credit_card_id,
                                  :credit_card_attributes => [:id, :user_id, :card_number, :exp_month, :exp_year, :ccv]
                                  ).merge(:checkout_date => Time.now)
  end

end
