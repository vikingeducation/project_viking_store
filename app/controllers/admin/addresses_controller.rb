class Admin::AddressesController < AdminController
  before_action :set_address, :except => [:index]

  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @addresses = Address.where('user_id = ?', params[:user_id])
      else
        flash.now[:error] = 'Invalid user'
      end
    end
    @addresses = Address.all unless @addresses
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @address.update(address_params)
      flash[:success] = 'Address created'
      redirect_to admin_user_addresses_path(@address.user)
    else
      flash.now[:error] = 'Address not created'
      render :new
    end
  end

  def update
    if @address.update(address_params)
      flash[:success] = 'Address updated'
      redirect_to admin_address_path(@address)
    else
      flash.now[:error] = 'Address not updated'
      render :edit
    end
  end

  def destroy
    if @address.destroy
      flash[:success] = 'Address deleted'
    else
      flash[:error] = 'Address not deleted, addresses of placed orders cannot be deleted'
    end
    redirect_to admin_addresses_path
  end


  private
  def set_address
    @address = Address.exists?(params[:id]) ? Address.find(params[:id]) : Address.new
  end

  def address_params
    params.require(:address).permit(
      :street_address,
      :secondary_address,
      :zip_code,
      :city_id,
      :state_id,
      :user_id
    )
  end
end
