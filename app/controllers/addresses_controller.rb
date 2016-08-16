class AddressesController < ApplicationController
  def index
    @user_id = params[:user_id]
    if @user_id
      @addresses = Address.where("user_id=?", @user_id)
    else
      @addresses = Address.all
    end
  end

  def show
    @address = Address.find(params[:id])
  end
end
