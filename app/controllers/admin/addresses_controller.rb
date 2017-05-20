class Admin::AddressesController < ApplicationController
  layout "admin"

  def index
    @addresses = user_addresses || Address.all
  end

  def show
    @address = Address.find(params[:id])
  end

  def new
    # check if the user_id is real
    unless User.exists?(params[:user_id])
      flash[:warning] = "The user_id #{params[:user_id]} does not exist"
      return redirect_to root_path
    end
    @city = City.new
    @user = User.find(params[:user_id])
    @address = Address.new
    @state_options = State.all.map{|s| [s.name, s.id]}
  end

  def create
    # check if the user_id is real
    unless User.exists?(params[:user_id])
      flash[:warning] = "The user_id #{params[:user_id]} does not exist"
      return redirect_to root_path
    end
    @user = User.find(params[:user_id])
    @city = get_or_create_city(params[:city])
    # add the city_id to the address_params
    @address = @user.addresses.build(address_params.merge({:city_id => @city.id}))
    if @address.save
      flash[:success] = "Address created successfully"
      redirect_to admin_addresses_path(:user_id => @user.id)
    else
      flash.now[:danger] = "Failed to create address"
      @state_options = State.all.map{|s| [s.name, s.id]}
      render :new
    end
  end

  def edit
    @address = Address.find(params[:id])
    @user = @address.user
    @city = @address.city
    @state_options = State.all.map{|s| [s.name, s.id]}
  end

  def update
    @address = Address.find(params[:id])
    @city = get_or_create_city(params[:city])
    if @address.update(address_params.merge({:city_id => @city.id}))
      flash[:success] = "Address updated successfully"
      redirect_to admin_address_path(@address.id)
    else
      @user = @address.user
      @state_options = State.all.map{|s| [s.name, s.id]}
      flash[:danger] = "Failed to update address"
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "Address deleted successfully"
      redirect_to admin_addresses_path
    else
      flash[:danger] = "Failed to delete address"
      redirect_back
    end
  end

  # ------------------------------------------------------------------
  # Helpers
  # ------------------------------------------------------------------

  # Filter addresses by user
  def user_addresses
    if params[:user_id]
      if User.exists?(params[:user_id])
        # The view is cutomized based on the presence of the `@user` var
        @user = User.find(params[:user_id])
        return @user.addresses
      else
        flash[:warning] = "The user_id #{params[:user_id]} does not exist"
        false
      end
    end
  end

  def get_or_create_city(name)
    if City.exists?(:name => name)
      City.find_by(:name => name)
    else
      City.create(:name => name)
    end
  end

  def address_params
    params.require(:address).permit(:street_address, :state_id, :city_id, :zip_code)
  end

end
