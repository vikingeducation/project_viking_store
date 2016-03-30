class UsersController < ApplicationController
  
  layout 'admin_portal'

  def index
    @column_headers = ["ID","Name","Joined","City","State","Orders","Last Order Date", "SHOW", "EDIT", "DELETE"]
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @user_orders_table_headers = ["ID","Order Date","Order Value","Status","SHOW", "EDIT", "DELETE"]
    @orders = Order.where(:user_id => params[:id])
  end
end