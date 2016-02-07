class AddressesController < ApplicationController
  layout "admin"

  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
        @addresses = Address.where(user_id: @user.id)
      else
        flash[:error] = "Invalid user id"
        redirect_to addresses_path
      end
    else
      @addresses = Address.all
    end
  end

  def new
    @address = Address.new(user_id: params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    @address = Address.new(whitelisted_address_params)
    if @address.save
      flash[:success] = "Address successfully created"
      redirect_to user_address_path(@address.user, @address)
    else
      flash[:error] = "Address was not created"
      render :new
    end
  end

  def show
    @address = Address.find(params[:id])
    @user = @address.user
  end


  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(whitelisted_address_params)
      flash[:success] = "Address successfully updated"
      redirect_to user_address_path(@address.user, @address)
    else
      render :edit
    end
  end    


  def destroy
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "Address successfully deleted"
    else
      flash[:error] = "Unable to delete address"
    end
    redirect_to addresses_path
  end



  def whitelisted_address_params
    params.require(:address).permit(:street_address, :secondary_address, :city_id, :state_id, :user_id, :zip_code)
  end


end
