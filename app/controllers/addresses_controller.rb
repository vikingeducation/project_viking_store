class AddressesController < ApplicationController

  def index
    if params[:user_id] 
      if User.exists?(params[:user_id])
        @addresses = Address.where(:user_id => params[:user_id])
        @user = User.find(params[:user_id])
      else
        flash[:warning] = "User could not be found!"
        @addresses = Address.all
      end
    else
      @addresses = Address.all
    end
  end

  def show
    @address = Address.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
    @states = State.all
    @cities = City.all
  end

  def create
    @address = Address.new(params[:id])
    if @address.save
      flash[:success] = "Success!"
      redirect_to addresses_path(:user_id => @address.user_id)
    else
      flash[:warning] = @address.errors.full_messages
      redirect_to(:back)
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
    @states = State.all
    @cities = City.all
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:success] = "Success"
      redirect_to address_path(params[:id])
    else
      flash[:warning] = @address.errors.full_messages
      redirect_to(:back)
    end
  end

  def destroy
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "Success!"
      redirect_to addresses_path
    else
      flash[:warning] = @address.errors.full_messages
      redirect_to(:back)
    end
  end

  private

  def address_params
    params.require(:address).permit(:user_id, :street_address, :state_id, :city_id, :zip_code)
  end

end
