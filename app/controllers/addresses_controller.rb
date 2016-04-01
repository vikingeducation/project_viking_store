class AddressesController < ApplicationController

  layout "admin_portal"

  def for_user
    @user_name = User.find(params[:user_id]).full_name
    @column_headers = ["ID","User","Address","City","State","Orders Shipped To","Created","SHOW","EDIT","DELETE"]
    @addresses = Address.where(:user_id => params[:user_id])
  end

  def index
    @column_headers = ["ID","User","Address","City","State","Orders Shipped To","Created","SHOW","EDIT","DELETE"]
    @addresses = Address.all
  end

  def show

  end

end
