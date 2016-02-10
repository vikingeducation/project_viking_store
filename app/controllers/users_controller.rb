class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(whitelisted_params)
    if @user.save
      flash[:success] = "Welcome, #{@user.full_name}!"
      sign_in(@user)
      redirect_to products_path
    else
      flash[:error] = "Failed to create user"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  private

  def whitelisted_params
    params.require(:user).permit(:email,
                                  :first_name,
                                  :last_name,
                                  :phone_number,
                                  { :addresses_attributes => [:id, :user_id, :street_address, :city_id, :state_id, :zip_code] })
  end
end
