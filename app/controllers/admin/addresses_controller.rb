class Admin::AddressesController < ApplicationController

  layout 'admin_portal_layout'

  def index
    unless params[:user_id].nil?
      @addresses = Address.where(user_id: params[:user_id]).includes(:user, :state, :city)
      @user = user
      @orders = orders_to_this_address(@user.id)
      session[:user] = @user
    else
      @addresses = Address.all.includes(:orders)
    end
  end


  def show
    @address = Address.where(id: params[:id]).includes(:user, :state, :city).first
    @user = @address.user
    @user_name = user_full_name
    @city = @address.city
  end


  def new
    @user = User.find(params[:user_id])
    @address = Address.new
    @city = @address.build_city
  end


  def create
    @user = User.find(params['address']['user_id'])
    @address = create_address_from_params
    save_address(@address)
  end


  def edit
    @address = Address.find(params[:id])
    @city = @address.city
    @user = @address.user
  end


  def update
    @address = Address.find(params[:id])
    if @city = City.find_or_create_by(name: whitelisted_params['city_attributes']['name'])
      if update_address_with_city(@address, @city)
        flash[:success] = "Address Successfully Updated!"
        redirect_to admin_address_path(@address)
      else
        flash[:danger] = "Address Could Not Be Updated See Errors On Form"
        render :edit
      end
    else
      @address.city = @city
      flash[:danger] = "Address Could Not Be Updated See Errors On Form"
      render :edit
    end
  end


  def destroy
    @address = Address.find(params[:id])
    if @address.orders.empty?
      if @address.destroy
        flash[:success] = "Address Successfully Deleted"
        redirect_to admin_user_addresses_path(@address.user_id)
      else
        flash[:danger] = "Could Not Delete Address"
        redirect_to admin_user_addresses_path(@address.user_id)
      end
    else
    end
  end


  private


  def create_address_from_params
    Address.create(
       user_id: whitelisted_params[:user_id],
       street_address: whitelisted_params[:street_address],
       state_id: whitelisted_params[:state_id],
       zip_code: whitelisted_params[:zip_code],
       city_id: City.find_or_create_by(name: whitelisted_params['city_attributes']['name']).id
     )
  end

  def update_address_with_city(address, city)
    address.update(
      user_id: whitelisted_params[:user_id],
      street_address: whitelisted_params[:street_address],
      state_id: whitelisted_params[:state_id],
      zip_code: whitelisted_params[:zip_code],
      city_id: city.id
    )
  end


  def whitelisted_params
    params.require(:address).permit(:user_id, :street_address, :state_id, :zip_code, { city_attributes: [:name] })
  end


  def city_params
    params.require(:city).permit(:name)
  end


  def orders_to_this_address(users_id)
    Order.where(user_id: users_id).
          group(:user_id).
          where.not(checkout_date: nil).
          count.
          values.
          first
  end


  def user
    User.find(params[:user_id])
  end


  def user_full_name
    @address.user.first_name + " " + @address.user.last_name
  end


  def save_address(address)
    if address.save
      flash[:success] = "Address Succesfully Saved"
      redirect_to admin_address_path(address)
    else
      flash[:danger] = "Address NOT saved - see errors on form"
      render :new
    end
  end



end
