class AddressesController < ApplicationController
  def index
    @user_id = params[:user_id]
    if @user_id
      @addresses = Address.where("user_id=?", @user_id)
    else
      @addresses = Address.all
    end
  end

  def show
    @address = Address.find(params[:id])
  end

  def new
    @address = Address.new(user_id: params[:user_id])
  end

  def create
    @address = Address.new(whitelisted_params)
    if @address.save
      flash[:success] = "Address successfully created"
      redirect_to user_addresses_path(@address.user_id)
    else
      flash[:error] = "Something went wrong"
      render :new
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(whitelisted_params)
      flash[:success] = "Address updated"
      redirect_to address_path(@address.id)
    else
      flash[:error] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "Address destroyed"
      redirect_to addresses_path
    else
      flash[:error] = "Something went wrong"
      redirect_to :back
    end
  end

  private

  def whitelisted_params
    params.require(:address).permit(:user_id,
                                    :street_address,
                                    :zip_code, 
                                    :city_id, 
                                    :state_id)
  end
end
