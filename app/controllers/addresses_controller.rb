class AddressesController < ApplicationController
  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @addresses = Address.where(user_id: params[:user_id])
        @user = User.find(params[:user_id])
      else
        flash.now[:error] = "Invalid User ID provided. Displaying all Addresses.."
        @addresses = Address.all
      end
    else
      @addresses = Address.all
    end

    render layout: "admin_portal"
  end
end
