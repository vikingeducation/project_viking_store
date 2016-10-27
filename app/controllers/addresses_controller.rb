class AddressesController < ApplicationController
  def index
    @addresses = Address.last(10)
  end

  def show
    @address = Address.find(params[:id])
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])

    if @address.update_attributes(white_listed_params)
      redirect_to @address
    else
      render "edit"
    end
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(white_listed_params)

    if @address.save
      redirect_to @address
    else
      render "new"
    end
  end

  def destroy
    Address.find(params[:id]).destroy
    redirect_to addresses_path
  end

  private
  def white_listed_params
    params.require(:address).permit(:street_address, :zip_code, :city_id, :state_id, :user_id)
  end
end
