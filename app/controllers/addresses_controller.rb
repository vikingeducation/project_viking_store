class AddressesController < ApplicationController

  layout "admin_portal"

  def create
    @address = Address.new(whitelisted_params)
    if @address.save
      redirect_to "/admin/addresses/user/#{whitelisted_params['user_id']}"
      flash[:notice] = "New Address Created!"
    else
      flash.now[:alert] = "New Address Could Not Be Created, Please Try Again."
      @user = User.find(params['address']['user_id'])
      render action: "new"
      # so it's after this that it happens, but where???
    end
  end

  def destroy
    Address.find(params[:id]).destroy
    redirect_to addresses_path
    flash[:notice] = "Address Deleted!"
  end

  def edit
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
    # if params["address"] then it means it's a render right
    if params["address"]
      @city_value = params["address"]["city"]
    # otherwise it's gonna be fresh from the address details
    else
      @city_value = Address.find(params[:id]).city.name
    end
  end

  def for_user
    @user_name = User.find(params[:user_id]).full_name
    @column_headers = ["ID","User","Address","City","State","Orders Shipped To","Created","SHOW","EDIT","DELETE"]
    @addresses = Address.where(:user_id => params[:user_id])
  end

  def index
    @column_headers = ["ID","User","Address","City","State","Orders Shipped To","Created","SHOW","EDIT","DELETE"]
    params[:user_id] ? @addresses = Address.where(:user_id => params[:user_id]) : @addresses = Address.all
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
  end

  def show
    @address = Address.find(params[:id])
  end

  # This needs some serious cleaning up.
  # It's a mess because I'm trying to re-render the page with previously entered inputs or if it's a fresh edit, to load the address details etc etc. Really big mess but I don't feel like looking at it right now. 
  def update
    @address = Address.find(params[:id])
    if params["address"]["city"] != ""
      if @address.update_attributes(whitelisted_params)
        redirect_to @address
        flash[:notice] = "Address Updated!"
      else
        flash.now[:alert] = "Address Could Not Be Updated, Please Try Again."
        @user = User.find(params['address']['user_id'])
        render action: "new"
      end
    else
      flash.now[:alert] = "Address Could Not Be Updated, Please Try Again."
      @user = User.find(params['address']['user_id'])
      render action: "new"
    end
  end

  private

  # How does the city value calculate itself

  def city_id_hash
    if City.where(:name => params["address"]["city"].downcase.titleize).first
      {:city_id => City.where(:name => params["address"]["city"].downcase.titleize).first.id}
    elsif params["address"]["city"].length > 0
      new_city = City.create(name: params["address"]["city"].downcase.titleize)
      {:city_id => new_city.id}
    else
      {:city_id => ""}
    end
  end

  def whitelisted_params
    if params["address"]["city"] != ""
      params.require(:address).permit(:street_address,:zip_code,:state_id, :user_id).merge(city_id_hash)
    else
      params.require(:address).permit(:street_address,:zip_code,:state_id, :user_id)
    end
  end

end
