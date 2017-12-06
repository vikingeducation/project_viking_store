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
    @city = City.new
  end


  def create
    @user = User.find(params['address']['user_id'])
    @city = City.new(city_params)
    @address = @user.addresses.new(whitelisted_params)
    if params['city']['name'].empty?
      flash[:danger] = "Could NOT save City - See form errors"
      render :new
    elsif City.where(name: params['city']['name']).exists?
      @address[:city_id] = City.where(name: params['city']['name']).first.id
      save_address(@address)
    else
      if @city.save
        @address[:city_id] = @city.id
        save_address(@address)
      else
        flash[:danger] = "Could NOT save City - See form Errors"
        render :new
      end
    end
  end


  def edit
    @address = Address.find(params[:id])
    @user = User.find(@address[:user_id])
    @city = City.find(@address[:city_id])
  end


  def update
    @address = Address.find(params[:id])
    @user = User.find(@address[:user_id])
    if params['city']['name'].empty?
      flash[:danger] = "Could NOT save City - See form errors"
      render :new
    elsif City.where(name: params['city']['name']).exists?
      @address[:city_id] = City.where(name: params['city']['name']).id
      save_address(@address)
    else
      @city = City.find(@address[:city_id])
      if @city.update(city_params)
        @address[:city_id] = @city.id
        save_address(@address)
      else
        flash[:danger] = "Could NOT save City - See form Errors"
        render :new
      end
    end
  end


  def destroy
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "Address Successfully Deleted"
      redirect_to admin_user_addresses_path(@address.user_id)
    else
      flash[:danger] = "Could Not Delete Address"
      redirect_to admin_user_addresses_path(@address.user_id)
    end
  end


  private


  def whitelisted_params
    params.require(:address).permit(:user_id, :street_address, :city_id, :state_id, :zip_code, { city: [:name] })
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
