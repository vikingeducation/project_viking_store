class AddressesController < ApplicationController
  before_action :find_address, only: [:show, :edit, :update]
  before_action :find_user, only: [:show, :new, :create, :edit, :update]

  def all
    @addresses = Address.all

    render "index", layout: "admin_portal"
  end

  def index
    if User.exists?(params[:user_id])
      @addresses = Address.where(user_id: params[:user_id])
      @user = User.find(params[:user_id])
    else
      flash.now[:error] = "Invalid User ID provided. Displaying all Addresses.."
      @addresses = Address.all
    end

    render layout: "admin_portal"
  end

  def show
    render layout: "admin_portal"
  end

  def new
    @address = Address.new

    render layout: "admin_portal"
  end

  def create
    address_params = whitelisted_address_params

    # normalize City name (unfortunately, it's passed to the controller in the misleading city_id param)
    city_name = address_params[:city_id].downcase.capitalize
    address_params[:city_id] = City.find_or_create_by(name: city_name).id unless city_name.empty?

    @address = @user.addresses.build(address_params)

    if @address.save
      flash[:success] = "Address successfully created."
      redirect_to user_addresses_path(@user)
    else
      flash.now[:error] = "Error creating Address."

      # destroy the City if the Address is not saved
      City.destroy(@address.city_id) unless @address.city_id.nil?
      @address.city_id = city_name

      render "new", layout: "admin_portal"
    end
  end

  def edit
    city_name = City.find(@address.city.id).name
    @address.city_id = city_name

    render layout: "admin_portal"
  end

  def update
    address_params = whitelisted_address_params

    # normalize City name (unfortunately, it's passed to the controller in the misleading city_id param)
    city_name = address_params[:city_id].downcase.capitalize
    address_params[:city_id] = City.find_or_create_by(name: city_name).id unless city_name.empty?

    if @address.update(address_params)
      flash[:success] = "Address successfully updated."
      redirect_to user_address_path(@user, @address)
    else
      flash.now[:success] = "Error updating Address."

      # destroy the City if the Address is not updated
      City.destroy(@address.city_id) unless @address.city_id.nil?
      @address.city_id = city_name

      render "new", layout: "admin_portal"
    end
  end

  private

  def find_address
    @address = Address.find(params[:id])
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def whitelisted_address_params
    params.require(:address).permit(:street_address, :zip_code, :city_id, :state_id)
  end
end
