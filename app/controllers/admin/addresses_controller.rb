class Admin::AddressesController < ApplicationController
  layout 'admin'
  def index
    @user = User.exists?(params[:user_id]) if params[:user_id]
    if @user
      @user = User.find(params[:user_id])
      @addresses = @user.addresses
    else
      flash[:error] = "Sorry, that user doesn't exist. Displaying all addresses instead" if params[:user_id]
      @addresses = Address.all.limit(10)
    end
  end

  def show
    @address = Address.find(params[:id])
    @user = @address.user
  end

  def new
    @user = User.exists?(params[:user_id]) if params[:user_id]
    if @user
      @user = User.find(params[:user_id])
      @address = Address.new
      @city = City.new
      @states = states_as_options
    else
      flash[:error] = "Sorry, that user doesn't exist, so we can't create an address for them"
      redirect_to admin_users_path
    end
  end

  def create
    @user = User.exists?(params[:user_id]) if params[:user_id]
    @states = states_as_options
    if @user
      @user = User.find(params[:user_id])
      @address = @user.addresses.build(whitelisted_params)
      if city_exists?
        @address.city = City.where("name ILIKE '#{whitelisted_city[:name]}'").first
      else
        @city = @address.build_city(whitelisted_city)
        @city.save
      end
      if @address.save
        flash[:success] = "Success! New addresses created"
        redirect_to admin_user_addresses_path(@user, @address)
      else
        flash[:errro] = "Sorry, we couldn't create that address. Please check the form for errors!"
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



  private

  def whitelisted_params
    if params[:address]
      params.require(:address).permit(:street_address, :state_id, :zip_code)
    end
  end

  def whitelisted_city
    params.require(:address).require(:city).permit(:name)
  end

  def city_exists?
    unless whitelisted_city[:name].empty?
      return City.where("name ILIKE '#{whitelisted_city[:name]}'").first.nil? ? false : true
    end
    false
  end

  def cities_as_options
    City.order('name').map do |c|
      [c.name, c.id]
    end
  end

  def states_as_options
    State.order('name').map do |s|
      [s.name, s.id]
    end
  end

  def get_or_create_city
    city = City.where("name = '#{params[:city][:name]}'").first
    if city
      return city.id
    else
      City.create(whitelisted_city) if params[:city][:name].size > 1
    end

  end
end
