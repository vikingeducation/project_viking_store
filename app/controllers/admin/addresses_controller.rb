class Admin::AddressesController < AdminController
  layout 'admin'

  def index
    if params[:user_id]
      if User.exists?(:id => params[:user_id])
        @addresses = User.find(params[:user_id]).addresses.paginate(:page => params[:page])
      else
        @addresses = Address.paginate(:page => params[:page])
        flash[:error] = "No such user. Displaying all results instead."
      end
    else
      @addresses = Address.paginate(:page => params[:page])
    end
  end

  def show
    @address = Address.find(params[:id])
  end

  def new
    @address = Address.new
    @city = @address.build_city
  end

  def create
    @address = Address.new(address_params)
    if @address.save
      flash[:success] = "Address has been created!"
      redirect_to admin_address_path(@address, :user_id => @address.user.id)
    else
      redirect_to new_admin_address_path(:user_id => @address.user.id)
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:success] = "Address has been updated!"
      redirect_to admin_addresses_path(:user_id => @address.user.id)
    else
      redirect_to edit_admin_address_path(@address, :user_id => @address.user.id)
    end
  end

  def destroy
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "Address has been deleted!"
      redirect_to request.referer
    end
  end

  private

  def address_params
    params.require(:address).permit(:street_address,
                                     :secondary_address,
                                     :zip_code,
                                     :state_id,
                                     :user_id,
                                     :city_attributes => [:id, :name])
  end

end
