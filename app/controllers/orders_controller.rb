class OrdersController < ApplicationController

  layout 'front_facing'

  # First off, I want this to only work if the user is currently signed in and only if the order belongs to the signed_in user... 
  def edit
    # First - making sure that the user is signed in.
    if signed_in_user?
      # Second - making sure the order in the params is that user's shopping cart
      if current_user.orders.where(:checkout_date => nil).first.id == params[:id].to_i
        @order = Order.find(params[:id])
      else
        flash[:alert] = "You can only checkout your current shopping cart."
        redirect_to shoppingcart_path
      end
    else
      flash[:alert] = "Please sign in or sign up to check out."
      redirect_to new_session_path
    end
  end

end
