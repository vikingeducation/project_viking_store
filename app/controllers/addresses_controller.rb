class AddressesController < ApplicationController

  layout "admin_portal"

  def create
    @address = Address.new(whitelisted_params.merge({:user_id => 1004}))
    if @address.save 
      redirect_to :addresses
      flash[:notice] = "New Address Created!"
    else
      flash.now[:alert] = "New Address Could Not Be Created, Please Try Again."
      render :new_a
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

  def city_id_hash
    if City.where(:name => params["address"]["city"].titleize).first
      {:city_id => City.where(:name => params["address"]["city"].downcase.titleize).first.id}
    else
      new_city = City.create(name: params["address"]["city"].downcase.titleize)
      {:city_id => new_city.id}
    end
  end

  def whitelisted_params
    params.require(:address).permit(:street_address,:zip_code,:state_id).merge(city_id_hash)
  end

end
