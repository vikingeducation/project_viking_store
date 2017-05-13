class Admin::OrdersController < ApplicationController

  layout 'admin_portal_layout'

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

end
