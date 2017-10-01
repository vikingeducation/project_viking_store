class AddressesController < ApplicationController

  def index
    @addresses = Address.all
  end

  def new
    @address = Address.new(user_id: params[:user_id])
    @addresses = Address.all
  end

  def create
     @address = Address.new(address_form_params)
    if @address.save
      flash[:success] = "Address created successfully."
      redirect_to user_address_path(@address)
    else
      flash[:error] = "Address not created"
      render :index
    end
  end

  def show
    @address = Address.find(params[:id])
  end

  def edit
    @address = Address.find(params[:id])
    @user = @address.user
  end

  def update
     @address = Address.find(params[:id])
    if @address.update_attributes(address_form_params)
    flash[:success] = "Address updated successfully."
    redirect_to user_address_path(@address)
    else
      flash[:error] = "Address not updated"
      render :show
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "Address deleted successfully."
      redirect_to user_addresses_path
    else
      flash[:error] = "Address not deleted"
      redirect_to session.delete(:return_to)
    end
  end

  
  private
    def address_form_params
      params.require(:user).permit(:street_address, :secondary_address, :zip_code, :city_id, :state_id, :user_id)
    end
  

end
