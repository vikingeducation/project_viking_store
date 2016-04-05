class OrdersController < ApplicationController

  layout 'admin_portal'

  def index
    @column_headers = ["ID", "UserID", "Address", "City", "State", "Total Value", "Status", "Date Placed", "SHOW", "EDIT", "DELETE"]
    if params[:user_id]
      @orders = Order.where(:user_id => params[:user_id])
      @orders_index_header = "#{User.find(params[:user_id]).full_name}'s Orders"
    else
      @orders = Order.all
      @orders_index_header = "Orders"
    end
  end

end
