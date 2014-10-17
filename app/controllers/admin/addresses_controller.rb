class Admin::AddressesController < AdminController
  def index
    if params[:user_id].nil?
      @addresses = Address.all
    else
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
        @addresses = Address.where(user_id: @user.id)
      else
        flash[:error] = "Invalid User Id"
        redirect_to admin_addresses_path
      end
    end
  end

  def new
    @address = Address.new(user_id: params[:user_id])
  end

  def create
    @address = Address.new(whitelisted_address_params)
    if @address.save
      flash[:success] = "Address created successfully."
      redirect_to admin_user_addresses_path(@address.user_id)
    else
      flash.now[:error] = "Failed to create Address."
      render 'new'
    end
  end

  def show
    @address = Address.find(params[:id])
    @user = @address.user
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update_attributes(whitelisted_address_params)
      flash[:success] = "Address updated successfully."
      redirect_to admin_user_addresses_path
    else
      flash.now[:error] = "Failed to update Address."
      render 'edit'
    end
  end

  def destroy
    @address = Address.find(params[:id])
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

  def whitelisted_address_params
    params.require(:address).permit(:street_address, :state_id, :city_id, :user_id, :zip_code)
  end
end
