class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  private

  def whitelisted_params
    params.require(:user).permit(:email,
                                  :first_name,
                                  :last_name,
                                  :phone_number,
                                  {:addresses_attributes => [:id, :user_id, :street_address, :city_id, :state_id, :zip_code]})
  end
end
