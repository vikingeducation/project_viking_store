class UserAddressesController < ApplicationController
  def index
    if User.find_by(:id => params[:user_id])
      @user = User.find_by(:id => params[:user_id])
      @user_addresses = @user.addresses
    else
      flash.now[:danger] = ["User not found!"]
      @addresses = Address.all
      render 'addresses/index'
    end
  end

  def new
  end
end
