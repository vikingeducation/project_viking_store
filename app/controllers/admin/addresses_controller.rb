class Admin::AddressesController < AdminController

  before_action :set_address, only: [:show, :edit, :update, :destroy]

  def index
    @addresses = Address.all
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
  end

  def create
    @user = User.find(params[:user_id])
    @address = @user.addresses.new(address_params)
    if @address.save
      flash[:notice] = "Address #{@address.street_address} has been created. Beeeewm."
      redirect_to admin_user_path(@user)
    else
      flash.now[:alert] = "Ah crap. Something went wrong."
      render :new
    end

  end

  def show

  end

  def edit
    @user = User.find(params[:user_id])
  end

  def update
    binding.pry
    @user = User.find(params[:user_id])
    if @address.update(address_params)
      flash[:notice] = "#{@address.street_address} was updated."
      redirect_to admin_user_path(@user)
    else
      flash.now[:error] = "Failed to update Address."
      render :edit
    end

  end

  def destroy
    session[:return_to] ||= request.referer
    if @address.destroy
      flash[:notice] = "#{@address.street_address} was deleted."
      redirect_to admin_user_addresses_path
    else
      flash[:error] = "Failed to delete #{@address.street_address}."
      redirect_to session.delete(:return_to)
    end
  end


  private

  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:street_address, :secondary_address, :zip_code, :city_id, :state_id, :user_id)
  end
end
