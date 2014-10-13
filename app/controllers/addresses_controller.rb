class AddressesController < ApplicationController
  def index
    if (params[:user_id] != nil)
      confirm_user_id
    else
      @addresses=Address.all
    end
    render :layout => "admin_interface"
  end

  def show
    @address = Address.find(params[:id])
    render :layout => "admin_interface"
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
    render :layout => "admin_interface"
  end

  def create
    @address = Address.new(address_params)
    if @address.save
      flash[:success] = "Address \"#{@address.street_address}\" has been successfully created!"
      redirect_to user_addresses_path(@address.user_id)
    else
      flash[:error] = "Address was not created, please try again"
      @user=User.find(@address.user_id)
      render 'new'
    end
  end

  private

  def address_params
    params.require(:address).permit(:user_id,:street_address, :city,:state,:zip)
  end


  def confirm_user_id
    if Address.where(id: params[:user_id]).empty?
        @addresses=Address.all
    else
        @addresses=Address.where(user_id: params[:user_id])
        @filtered = true
        @params_user_id = params[:user_id]
    end
  end

end
