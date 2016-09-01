class UserAddressesController < ApplicationController
  def index
    if User.find_by(:id => params[:user_id])
      @user = User.find_by(:id => params[:user_id])
      @user_addresses = @user.addresses
    else
      flash.now[:danger] = ["User not found!"]
      @addresses = Address.all
      render 'addresses/index'
    end
  end

  def new
    @address = Address.new(:user_id => params[:user_id])
  end

  def create
    @address = Address.new(white_list_params)
    if @address.save
      flash[:success] = ["Address has been saved successfully!"]
      redirect_to address_path(@address)
    else
      flash.now[:danger] = @address.errors.full_messages
      render :new
    end
  end

  private
    def white_list_params
      params.require(:address).permit(:user_id,
                                      :street_address,
                                      :city_id,
                                      :state_id,
                                      :zip_code)
    end


end
