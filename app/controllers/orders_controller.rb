class OrdersController < ApplicationController

  layout 'admin_portal'

  def index
    @column_headers = ["ID", "UserID", "Address", "City", "State", "Total Value", "Status", "Date Placed", "SHOW", "EDIT", "DELETE"]
    @orders = Order.all
  end

end
