class AddressesController < ApplicationController

  layout 'portal'

  def index

    @addresses = Address.get_index_data(params[:user_id])

    begin
      @filtered_user = User.find(params[:user_id]) if params[:user_id]
    rescue
      flash[:danger] = "User not found. Redirecting to Address Index."
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

    if @address.save
      flash[:success] = "Address created successfully!"
      redirect_to addresses_path(:user_id => @address.user_id)
    else
      flash.now[:danger] = "Address failed to save - please try again."
      @user = User.find(@address.user_id)
      @cities = City.order(:name).all
      @states = State.all
      render :new
    end

  end

  def edit

    @address = Address.find(params[:id])
    @user = User.find(@address.user_id)
    @cities = City.order(:name).all
    @states = State.all

  end

  def update

    @address = Address.find(params[:id])

    if @address.update(address_params)
      flash[:success] = "Address updated successfully!"
      redirect_to @address
    else
      flash.now[:danger] = "Address failed to update - please try again."
      @user = User.find(@address.user_id)
      @cities = City.order(:name).all
      @states = State.all
      render :edit
    end

  end

  def destroy

    @address = Address.find(params[:id])

    if @address.destroy
      flash[:success] = "Address deleted successfully!"
      redirect_to addresses_path(:user_id => @address.user_id)
    else
      flash[:danger] = "Address failed to be deleted - please try again."
      redirect_to :back
    end

  end

  def address_params

    params.require(:address).permit(:street_address, :city_id, :state_id, :zip_code, :user_id)

  end
  
end
