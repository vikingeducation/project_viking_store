class AddressesController < ApplicationController
  def index
    @addresses = Address.all
  end

  def show
    @address = Address.find(params[:id])
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address && @address.update(white_list_params)
      flash[:success] = ["Address has been updated"]
      redirect_to address_path(@address)
    else
      flash.now[:danger] = @address.errors.full_messages
      render :edit
    end
  end

  def destroy
    session[:return_to] = request.referer
    address = Address.find_by(:id => params[:id])
    if address && address.destroy
      flash[:success] = ["Address #{address.id} has been deleted!"]
      redirect_to addresses_path
    else
      flash[:danger] = address.errors.full_messages
      redirect_to session[:return_to]
      session.delete(:return_to)
    end
  end


  private
    def white_list_params
      params.require(:address).permit(:user_id,
                                      :street_address,
                                      :city_id,
                                      :state_id,
                                      :zip_code)
    end


end
