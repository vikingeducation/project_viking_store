class Admin::AddressesController < AdminController

  def index
    if @user = valid_user
      @addresses = @user.addresses
    elsif params[:user_id] # user_id there but invalid
      flash[:danger] = "Invalid User!"
      @addresses = Address.all
    else
      @addresses = Address.all
    end
  end


  def show
    @address = Address.find(params[:id])
  end


  def new
    if user = valid_user
      @address = user.addresses.new
      @address.build_city
    else
      flash[:danger] = "Address cannot be created without valid User!"
      redirect_to admin_addresses_path
    end
  end


  def create
    @address = Address.new(address_params)
    if @address.save
      flash[:success] = "New Address for #{@address.user.first_name} Created!"
      redirect_to admin_address_path(@address)
    else
      flash.now[:danger] = "Oops, something went wrong!"
      render :new
    end
  end


  def edit
    @address = Address.find(params[:id])
  end


  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:info] = "Address for #{@address.user.first_name} Updated!"
      redirect_to admin_address_path(@address)
    else
      flash.now[:danger] = "Oops, something went wrong!"
      render :edit
    end
  end


  private


  def address_params
    params.require(:address).permit(:user_id, :street_address, :state_id, 
                                    :zip_code, city_attributes: [:name])
  end


  def valid_user
    if params.has_key?(:user_id) && User.exists?(params[:user_id])
      User.find(params[:user_id])
    end
  end

end
