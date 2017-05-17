class Admin::OrdersController < ApplicationController
  layout "admin"

  def index
    @orders = get_orders
    @orders = @orders.where(:checkout_date => nil) if filter_by_unplaced?
    @orders = @orders.limit(100)
  end

  # ------------------------------------------------------------------------
  # Helpers
  # ------------------------------------------------------------------------

  def get_orders
    # Filter addresses by user, if provided
    if params[:user_id]
      if User.exists?(params[:user_id])
        # The view is cutomized based on the presence of the `@user` var
        @user = User.find(params[:user_id])
        Order.value_per_order.where(:user_id => @user.id)
      else
        flash[:warning] = "The user_id #{params[:user_id]} does not exist"
        false
      end
    else
      Order.value_per_order
    end
  end

  def filter_by_unplaced?
    if params[:status]
      params[:status].to_sym == :unplaced
    end
  end

end
