class Admin::AddressesController < AdminController

  before_action :set_address, only: [:show, :edit, :update, :destroy]

  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
        @addresses = Address.where(user_id: @user.id)
      else
        flash[:error] = "Invalid User Id"
        redirect_to admin_addresses_path
      end
    else
      @addresses = Address.all
    end
  end

  def new
    @address = Address.new(user_id: params[:user_id])
  end

  def create
    address = Address.new(whitelisted_address_params)
    if @address.save
      flash[:success] = "Address created successfully."
      redirect_to admin_user_addresses_path(@address.user_id)
    else
      flash.now[:error] = "Failed to create Address."
      render 'new'
    end
  end

  def show
    @user = @address.user
  end

  def edit
  end

  def update
    if @address.update_attributes(whitelisted_address_params)
      flash[:success] = "Address updated successfully."
      redirect_to admin_user_addresses_path
    else
      flash.now[:error] = "Failed to update Address."
      render 'edit'
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    if @address.destroy
      flash[:success] = "Address deleted successfully."
      redirect_to admin_user_addresses_path
    else
      flash[:error] = "Failed to delete Address."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end

  def whitelisted_address_params
    params.require(:address).permit(:street_address, :state_id, :city_id, :user_id, :zip_code)
  end
end
