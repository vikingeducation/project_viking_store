class AddressesController < ApplicationController

  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
        @addresses = @user.addresses
        render :index
      else
        flash.notice = "Improper user id"
        @addresses = Address.all
      end
    else
      @addresses = Address.all
    end
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
  end

  def create
    @user = User.find(params[:user_id])
    @address = Address.new(street_address: whitelisted_params[:street_address])
    @address.zip_code = "12345"
    @address.user = @user
    @address.citystate_name(whitelisted_params[:city][:name], whitelisted_params[:state][:name])

    if @address.save
      flash.notice = "You successfully created an address"
      redirect_to user_addresses_path(@user, @address)
    else

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
    @address.zip_code = "12345"
    # @address.update_name(whitelisted_params[:city][:name], whitelisted_params[:state][:name])
    @address.update(whitelisted_params)
    redirect_to user_addresses_path(@user)
  end

  def destroy
    @user = User.find(params[:user_id])
    @address.find(params[:id])
    @address.destroy
    redirect_to user_addresses_path(@user)
  end

  private
    def whitelisted_params
      params.require(:address).permit(:street_address, city: [:name], state: [:name])
    end

end
