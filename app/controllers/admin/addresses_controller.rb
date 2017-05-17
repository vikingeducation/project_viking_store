class Admin::AddressesController < ApplicationController
  layout "admin"

  def index
    @addresses = user_addresses || Address.all
  end

  def show
    @address = Address.find(params[:id])
  end

  # ------------------------------------------------------------------
  # Helpers
  # ------------------------------------------------------------------

  # Filter addresses by user
  def user_addresses
    if params[:user_id]
      if User.exists?(params[:user_id])
        # The view is cutomized based on the presence of the `@user` var
        @user = User.find(params[:user_id])
        return @user.addresses
      else
        flash[:info] = "The user_id #{params[:user_id]} does not exist"
        false
      end
    end
  end

end
