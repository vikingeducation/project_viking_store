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
    city = City.where(name: params[:city_name]).first_or_create
    @address.city_id = city.id
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
    @city = @address.city
  end

  def update
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
    city = City.where(name: params[:city_name]).first_or_create
    if @address.update_attributes(user_id: @user.id, city_id: city.id)
      flash[:success] = "You edit the address"
      redirect_to user_address_path(@user, @address)
    else
      flash.now[:danger] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    if update_user_address(@address)
      flash[:success] = "You succesfully deleted the address"
      redirect_to user_addresses_path(params[:user_id])
    else
      flash[:danger] = "Something went wrong"
      redirect_to(:back)
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

  def update_user_address(a)
    user = a.user
    a.update(:deleted => true)
    if user.billing_id == a.id
      if user.addresses.where(:deleted => false).count > 0
        user.billing_id = user.addresses.where(:deleted => false).first.id
      else
        user.billing_id = nil
      end
    end

    if user.shipping_id == a.id
      if user.addresses.where(:deleted => false).count > 0
        user.shipping_id = user.addresses.where(:deleted => false).first.id
      else
        user.shipping_id = nil
      end
    end
    user.save
  end

end
