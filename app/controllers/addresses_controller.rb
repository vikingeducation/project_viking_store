class AddressesController < ApplicationController

  layout 'portal'


  def index
    @addresses = Address.get_index_data(params[:user_id])

    begin
      @filtered_user = User.find(params[:user_id]) if params[:user_id]
    rescue
      flash[:danger] = "User not found.  Redirecting to Address Index."
      redirect_to addresses_path
    end

  end


  def show
    @address = Address.find(params[:id])
    @user = User.find(@address.user_id)
    @street = @address.street_address
    @city = @address.city.name
    @state = @address.state.name
  end


  def new
    @address = Address.new
    @user = User.find(params[:user_id])
    @cities = City.order(:name).all
    @states = State.all
  end


  def create
    @address = Address.new(address_params)
    @user = User.find(@address.user_id)

    if @address.save
      flash[:success] = "Address successfully created!"
      redirect_to addresses_path(:user_id => @user.id)
    else
      flash.now[:danger] = "Address not saved - please try again."
      @cities = City.order(:name).all
      @states = State.all
      render :new
    end
  end


  private


  def address_params
    params.require(:address).permit(:street_address, :city_id, :state_id, :zip_code, :user_id)
  end


end
