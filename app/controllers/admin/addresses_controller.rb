class Admin::AddressesController < AdminController
  layout "admin"
  def index
    @addresses = Address.user_order(params[:user_id])
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(whitelisted_address_params)
    if @address.save
      flash[:success] = "Address created!"
      redirect_to admin_addresses_path(user_id: @address.user_id)
    else
      flash[:error] = @address.errors.full_messages.to_sentence
      render "/addresses/new"
    end
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(whitelisted_address_params)
      flash[:success] = "Address updated!"
      redirect_to admin_addresses_path
    else
      flash[:error] = @address.errors.full_messages.to_sentence
      render "/admin/addresses/edit"
    end
  end

  def destroy
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "Address obliterated!"
      redirect_to admin_addresses_path
    else
      flash[:error] = @address.errors.full_messages.to_sentence
      render "/admin/addresses"
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def show
    @address = Address.find(params[:id])
  end

  def whitelisted_address_params
    params.require(:address).permit(:street_address, :secondary_address, :zip_code, :state_id, :city_id, :user_id)
  end
end
