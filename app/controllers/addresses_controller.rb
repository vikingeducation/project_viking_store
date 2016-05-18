class AddressesController < ApplicationController
  def index
    @addresses = Address.all

    user_id_in_params

  end

  def show
    @address = Address.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @address = @user.addresses.new
  end

  def create
    @user = User.find(params[:user_id])
    @address = Address.new(whitelisted_params)
    @address.user_id = @user.id
    if @address.save
      flash[:success] = "You created a new address"
      redirect_to user_addresses_path(@user)
    else
      flash.now[:danger] = "Something went wrong"
      render :new
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @address = Address.new(whitelisted_params)
    @address.user_id = @user.id
    if @address.save
      flash[:success] = "You edit the address"
      redirect_to user_address_path(@user, @address)
    else
      flash.now[:danger] = "Something went wrong"
      render :edit
    end
  end


  private

  def whitelisted_params
    params.require(:address).permit(:street_address, :city_id, :state_id, :zip_code, :user_id)
  end

  def user_id_in_params
    if params[:user_id]
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
      else
        flash.now[:danger] = "User #{params[:user_id]} cannot be found"
      end
    end
  end
end
