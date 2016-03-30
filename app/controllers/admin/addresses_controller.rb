class Admin::AddressesController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @addresses = @user.addresses
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
  end

  def create
    @user = User.find(params[:user_id])
    @address = Address.new(whitelisted_params)
    if @address.save
      flash[:success] = 'Address created.'
      redirect_to admin_user_addresses_path(@user)
    else
      flash.now[:error] = 'Address failed to create.'
      render 'new'
    end
  end

  def show
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
  end

  def edit
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
    if @address.update(whitelisted_params)
      flash[:success] = 'Address updated.'
      redirect_to admin_user_addresses_path(@user)
    else
      flash.now[:error] = 'Address failed to update.'
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
    if @address.delete
      flash[:success] = 'Address updated.'
      redirect_to admin_user_addresses_path(@user)
    else
      flash[:error] = 'Address failed to delete.'
      redirect_to admin_user_addresses_path(@user)
    end
  end

  private

  def whitelisted_params
    params.require(:address).permit(:street_address, :secondary_address, :city_id, :state_id, :zip_code)
  end

end