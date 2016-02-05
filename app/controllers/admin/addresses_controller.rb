class Admin::AddressesController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @addresses = @user.addresses
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
  end

end