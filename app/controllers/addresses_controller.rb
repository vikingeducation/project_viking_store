class AddressesController < ApplicationController
  layout 'admin'

  def show
    @address = Address.find(params[:id])
  end

  def index
      if !params[:user_id].nil?
      @user = User.where("id = ?", params[:user_id]).first
      flash[:error] = "User does not exist!" if @user.nil?
    end
    if @user.nil?
      @addresses = Address.all.sort
    else
      @user
      @addresses = @user.addresses
    end
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
    @states = State.all.sort
  end

  def create

  end

  def edit
    @address = Address.find(params[:id])
    @user = User.find(params[:user_id])
    @states = State.all.sort
  end

  def update

  end

  def destroy

  end

  def address_params
    params.require(:address).permit(:street_address, :secondary_address, :zip_code, :city_id, :state_id, :user_id)
  end
end
