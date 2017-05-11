class Admin::AddressesController < ApplicationController

  layout 'admin_portal_layout'

  def index
    if params[:user_id]
      @addresses = Address.where(:user_id => params[:user_id])
    else
      @addresses = Address.all
    end
  end

  def show
    @address = Address.find(params[:id])
  end

  def new
    @address = Address.new(:user_id => params[:user_id])
  end

  def create
    @address = Address.new(whitelisted_address_params)
    if @address.save
      flash[:success] = "New Address has been saved"
      redirect_to admin_addresses_path(:user_id => "#{@address.user_id}")
    else
      flash.now[:danger] = "New Address WAS NOT saved. Try again."
      render 'new', :locals => {:address => @address}
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update_attributes(whitelisted_address_params)
      flash.now[:success] = "Address has been updated"
      redirect_to admin_address_path
    else
      flash[:danger] = "Address hasn't been saved."
      render 'edit', :locals => {:address => @address}
    end
  end

  def destroy
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "Address deleted successfully!"
      redirect_to admin_addresses_path
    else
      flash[:danger] = "Failed to delete the address"
      redirect_to request.referer
    end
  end

  private
  def whitelisted_address_params
    params.require(:address).permit(:street_address, :secondary_address, :zip_code, :city_id, :state_id, :user_id, :city_name)
  end


end
