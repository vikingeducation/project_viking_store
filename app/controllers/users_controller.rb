class UsersController < ApplicationController

  def new
    @user = User.new
    @user.addresses.build
    @user.addresses.build
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash.notice = "You successfully saved"
      redirect_to products_path
    else
      flash.notice = "It failed"
      render :new
    end

  end


  private

    def user_params
      params.require(:user).permit(
        :first_name, 
        :last_name, 
        :email,
        addresses_attributes:[
          :street_address, 
          :state_id, 
          :zip_code,
          :city_id
          ]
        )
    end


end
