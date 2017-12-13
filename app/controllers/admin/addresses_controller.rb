class Admin::AddressesController < AdminController

  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:new, :create]

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
    binding.pry
  end

  def update
    binding.pry
    @user = User.find(params[:user_id])
    if @address.update(address_params)
      flash[:success] = "Address updated successfully."
      redirect_to admin_user_path(@user)
    else
      flash.now[:error] = "Failed to update Address."
      render :edit
    end

  end

  def index
  end

  def destroy
  end


  private

  def set_address
    @address = Address.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def address_params
    params.require(:address).permit(:street_address, :secondary_address, :zip_code, :city_id, :state_id, :user_id)
  end
end
