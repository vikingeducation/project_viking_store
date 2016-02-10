class UsersController < ApplicationController

  def index
  end

  def new
    @user = User.new
    2.times { @user.addresses.build }
  end

  def create
    @user = User.new(whitelisted_params)
    if @user.save
      flash[:success] = "New user created"
      redirect_to products_path
    else
      flash[:error] = "Signup failed"
      render :new
    end
  end



  def whitelisted_params
    params.require(:user).permit(:email, :first_name, :last_name, :telephone, {addresses_attributes: [
                              :id, :user_id, :street_address, :city_id, :state_id, :zip_code]})

  end

end
