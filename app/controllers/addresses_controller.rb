class AddressesController < ApplicationController
  layout "admin", only: [:index, :new, :show, :edit]
  def index
    user_id = params[:user_id]
    if User.exists?(user_id)
      @addresses = Address.where("user_id = ?", user_id)
    else
      @addresses = Address.all
    end
  end

  def show
    @address = Address.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @address = @user.addresses.build
  end

  def create
    @address = Address.new whitelisted_address_params
    if @address.save
      flash[:success] = "You created a new address."
      redirect_to user_addresses_path(params[:address][:user_id])
    else
      flash[:error] = "There is an error."
      render :new
    end
  end

  private

  def whitelisted_address_params
    params.require(:address).permit(:user_id, :street_address, :city_id, :state_id, :zip_code)
  end

end
