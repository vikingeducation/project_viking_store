class AddressesController < ApplicationController

  layout 'portal'


  def index
    @addresses = Address.get_index_data(params[:user_id])

    begin
      @filtered_user = User.find(params[:user_id]) if params[:user_id]
    rescue
      flash[:danger] = "User not found.  Redirecting to Address Index."
      redirect_to addresses_path
    end

  end


  def show
    @address = Address.find(params[:id])
    @user = User.find(@address.user_id)
    @street = @address.street_address
    @city = @address.city.name
    @state = @address.state.name
  end

end
