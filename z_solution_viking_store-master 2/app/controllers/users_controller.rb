class UsersController < ApplicationController

  def new
    @user = User.new
    2.times { @user.addresses.build }
  end

  def create
    @user = User.new(whitelisted_params)
    if @user.save
      set_default_addresses
      flash[:success] = "Wanna buy an axe?"
      sign_in(@user)
      redirect_to products_path
    else
      flash[:error] = "Signup failed because REASONS."
      render :new
    end
  end

  def update
    @user = current_user

    if @user.update(whitelisted_params)
      set_defaults
      flash[:success] = "Account updated."
      redirect_to products_path
    else
      flash[:error] = "Something went wrong."
      render :edit
    end
  end

  def edit
    @user = current_user
    @user.addresses.build
  end

  def destroy
    @user = User.find(params[:id])
    session[:return_to] ||= request.referer
    if @user.destroy && sign_out
      flash[:success] = "user deleted successfully."
      redirect_to products_path
    else
      flash[:error] = "Failed to delete User."
      render 'edit'
    end
  end

  private

  def whitelisted_params
    check_cities
    params.require(:user).permit(:email,
                                :first_name,
                                :last_name,
                                :phone_number,
                                {:addresses_attributes => [:id, :user_id, :street_address, :city_id, :state_id, :zip_code, :_destroy]})
  end

  def check_cities
    addresses = params[:user][:addresses_attributes]
    address_keys = addresses.keys

    address_keys.each do |key|
      next if addresses[key][:city_id] == ""
      addresses[key][:city_id] = check_city(key, addresses[key][:city_id])
    end

  end

  def check_city(key, city)

    if City.find_by(name: city)
      City.find_by(name: city).id
    else
      c = City.create(name: city)
      c.id
    end

  end

  def set_default_addresses
    addresses = params[:user][:addresses_attributes]
    billing = params[:user][:billing_id]
    shipping = params[:user][:shipping_id]


    if billing
      billing_street = addresses[billing][:street_address]
      @user.billing_address = @user.addresses.find_by(street_address: billing_street)
    end

    if shipping
      shipping_street = addresses[shipping][:street_address]
      @user.shipping_address = @user.addresses.find_by(street_address: shipping_street)
    end

    @user.save
  end

end
