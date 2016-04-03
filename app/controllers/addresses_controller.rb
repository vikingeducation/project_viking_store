class AddressesController < ApplicationController

  layout "admin_portal"

  def index
    @column_headers = ["ID","User","Address","City","State","Orders Shipped To","Created","SHOW","EDIT","DELETE"]
    @addresses = Address.all
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
  end

  def show
    @address = Address.find(params[:id])
  end

  def for_user
    @user_name = User.find(params[:user_id]).full_name
    @column_headers = ["ID","User","Address","City","State","Orders Shipped To","Created","SHOW","EDIT","DELETE"]
    @addresses = Address.where(:user_id => params[:user_id])
  end

end
