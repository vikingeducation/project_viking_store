class AddressesController < ApplicationController

  def index
    @addresses = Address.all
    @this_user = params[:this_user].to_i
    if @this_user != 0
      @this_user = User.find(@this_user)
      @addresses = @this_user.addresses
    end
  end

  def new
    @address = Address.find(params[:user_id])
  end

  def show
    @address = Address.find(params[:id])
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
  end

  def destroy
  end
end
