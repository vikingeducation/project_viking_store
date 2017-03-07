class Admin::AddressesController < ApplicationController
  layout 'admin'
  def index
    @user = User.exists?(params[:user_id]) if params[:user_id]
    if @user
      @user = User.find(params[:user_id])
      @addresses = @user.addresses
    else
      flash[:error] = "Sorry, that user doesn't exist. Displaying all addresses instead" if params[:user_id]
      @addresses = Address.order('user_id').limit(10)
    end
  end

  def show
    @address = Address.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def new
    @user = User.exists?(params[:user_id]) if params[:user_id]
    if @user
      @user = User.find(params[:user_id])
      @address = Address.new
      @city = City.new
      @states = State.all
    else
      flash[:error] = "Sorry, that user doesn't exist, so we can't create an address for them"
      redirect_to admin_users_path
    end
  end

  def create
    @user = User.exists?(params[:user_id]) if params[:user_id]
    @states = State.all
    if @user
      @user = User.find(params[:user_id])
      @address = @user.addresses.build(whitelisted_params)
      if city_exists?
        @address.city = get_city
      else
        @city = @address.build_city(whitelisted_city)
        @city.save
      end
      if @address.save
        flash[:success] = "Success! New address created"
        redirect_to admin_user_addresses_path(@user, @address)
      else
        flash[:error] = "Sorry, we couldn't create that address. Please check the form for errors!"
        render :new
      end

    elsif @user.nil?
      flash[:error] = "Sorry, we can't create addresses for users that don't exist"
      redirect_to admin_addresses_path
    else
      flash[:error] = "Sorry, we couldn't create that address. Please check the form for errors "
      render :new
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
    @city = @address.city
    @states = State.all
  end

  def update
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
    @address.city = get_city || @address.create_city(whitelisted_city)
    @city = @address.city
    @states = State.all

    if @address.update(whitelisted_params)
      flash[:success] = "Success! The address has been updated!"
      redirect_to admin_addresses_path
    else
      flash[:error] = "Sorry! The address couldn't be updated"
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "Success! The address has been removed"
    else
      flash[:error] = "Sorry! The address could not be removed"
    end
    redirect_to admin_addresses_path
  end



  private

  def whitelisted_params
    if params[:address]
      params.require(:address).permit(:street_address, :state_id, :zip_code)
    end
  end

  def whitelisted_city
    params.require(:city).permit(:name)
  end

  def get_city
    City.where("name ILIKE '#{whitelisted_city[:name]}'").first
  end

  def city_exists?
    return false if whitelisted_city[:name].empty?
    City.where("name ILIKE '#{whitelisted_city[:name]}'").first.nil? ? false : true
  end


end
