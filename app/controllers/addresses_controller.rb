class AddressesController < ApplicationController
  layout 'admin'
  before_action :set_address, :except => [:index]

  def index
    @addresses = Address.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @address.update(address_params)
      flash[:success] = 'Address created'
      redirect_to addresses_path
    else
      flash.now[:error] = 'Address not created'
      render :new
    end
  end

  def update
    if @address.update(address_params)
      flash[:success] = 'Address updated'
      redirect_to addresses_path
    else
      flash.now[:error] = 'Address not updated'
      render :edit
    end
  end

  def destroy
    if @address.destroy
      flash[:success] = 'Address deleted'
    else
      flash[:error] = 'Address not deleted, may have placed orders'
    end
    redirect_to addresses_path
  end


  private
  def set_address
    @address = Address.exists?(params[:id]) ? Address.find(params[:id]) : Address.new
  end

  def address_params
    params.require(:address).permit(
      :street_address,
      :secondary_address,
      :zip_code,
      :city_id,
      :state_id,
      :user_id
    )
  end
end
