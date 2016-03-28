class UsersController < ApplicationController
  
  layout 'admin_portal'

  def index
    @column_names = ["ID","Name","Joined","City","State","Orders","Last Order Date", "SHOW", "EDIT", "DELETE"]
    @users = User.all_in_arrays
  end

  def show
    @user = User.find(params[:id])
    @user_orders_table_headers = ["ID","Order Date","Order Value","Statue","SHOW", "EDIT", "DELETE"]
    @orders = 
  end
end