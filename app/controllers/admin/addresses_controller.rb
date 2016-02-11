class Admin::AddressesController < AdminController

  def all_index
    @user_info = Address.get_user_address_info
  end
  
  def index
    @user = User.find(params[:user_id])
    @user_info = Address.get_user_address_info(@user.id)
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user_id = params[:user_id]
    if @address.save
      flash[:success] = "You've Sucessfully Created an User Address!"
      redirect_to [:admin, user_path(@address.user_id)]
    else
      flash.now[:error] = "Error! User Address wasn't created!"
      render :new
    end
  end

  def show
    @address = Address.find(params[:id])
    @address_info = Address.get_detailed_address_info(@address)
  end

  def edit
    @address = Address.find(params[:id])
    @address_info = Address.get_detailed_address_info(@address)
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:success] = "You've Sucessfully Updated the User Address!"
      redirect_to admin_user_address_path(@address.user.id, @address.id)
    else
      flash.now[:error] = "Error! User Address wasn't updated!"
      render :edit
    end
  end

  def destroy
     @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "You've Sucessfully Deleted the User Address!"
      redirect_to [:admin, user_addresses_path]
    else
      flash.now[:error] = "Error! User Address wasn't deleted!"
      render :show
    end
  end

  private

  def address_params
    params.require(:address).permit(:street_address, :city_id, :state_id, :zip_code)
  end
end