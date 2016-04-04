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

  def index
    @column_headers = ["ID","User","Address","City","State","Orders Shipped To","Created","SHOW","EDIT","DELETE"]
    @addresses = Address.all
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
  end

  def show
    @address = Address.find(params[:id])
  end

  def for_user
    @user_name = User.find(params[:user_id]).full_name
    @column_headers = ["ID","User","Address","City","State","Orders Shipped To","Created","SHOW","EDIT","DELETE"]
    @addresses = Address.where(:user_id => params[:user_id])
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
