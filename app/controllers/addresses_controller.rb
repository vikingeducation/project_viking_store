class AddressesController < ApplicationController

  def index
    @addresses = Address.all
    @user = params[:user_id].to_i
    if @user != 0
      @user = User.find(@user)
      @addresses = @user.addresses
    end
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
  end

  def create
    c = City.where("name='" + "#{params[:address][:city]}" + "'")
    c = City.create(name: params[:address][:city]) unless c[0]
    c = c[0] unless c.is_a?(City)
    #@address = Address.new(address_params, city_id: c[0].id, user_id: params[:user_id])
    @address = Address.new(
      street_address: params[:address][:street_address],
      city_id: c.id,
      state_id: params[:address][:state_id],
      zip_code: params[:address][:zip_code],
      user_id: params[:user_id]
    )
    if @address.save
      flash[:success] = "You've Sucessfully Created an Address!"
      redirect_to addresses_path(user_id: "#{params[:user_id]}")
    else
      flash.now[:error] = "Error! Address wasn't created!"
      render :new
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
    @address = Address.find(params[:id])

    c = City.where("name='" + "#{params[:address][:city]}" + "'")
    c = City.create(name: params[:address][:city]) unless c[0]
    c = c[0] unless c.is_a?(City)

    if @address.update(
      street_address: params[:address][:street_address],
      city_id: c.id,
      state_id: params[:address][:state_id],
      zip_code: params[:address][:zip_code],
      user_id: params[:user_id]
    )
      flash[:success] = "You've Sucessfully Updated the Address!"
      redirect_to address_path(@address.id, user_id: "#{@address.user.id}")
    else
      flash.now[:error] = "Error! Address wasn't updated!"
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    user_id = @address.user.id
    if @address.destroy
      flash[:success] = "You've Sucessfully Deleted an Address!"
      redirect_to addresses_path(user_id: user_id)
    else
      flash.now[:error] = "Error! User wasn't deleted!"
      render :show
    end
  end

  private

  def address_params
    params.require(:address).permit(:street_address, :state_id, :zip_code, :city_id, :user_id)
  end
end
