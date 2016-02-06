class AddressesController < ApplicationController
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
  end

  def create
    @address = Address.new(address_params)
    if @address.save
      flash[:success] = "Address has been created!"
      redirect_to address_path(@address, :user_id => @address.user.id)
    else
      redirect_to new_address_path(:user_id => @address.user.id)
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:success] = "Address has been updated!"
      redirect_to addresses_path(:user_id => @address.user.id)
    else
      redirect_to edit_address_path(@address, :user_id => @address.user.id)
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
    params.require(:address).permit(:street_address, :secondary_address, :zip_code, :city_id, :state_id, :user_id)
  end

end
