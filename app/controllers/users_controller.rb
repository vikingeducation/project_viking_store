class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(whitelisted_params)

    if @user.save
      @user.addresses.build
      flash[:success] = "Welcome, #{@user.full_name}!"
      sign_in(@user)
      redirect_to products_path
    else
      flash[:error] = "Failed to create user"
      render 'new'
    end
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
    @user.addresses.build
  end

  def update
    @user = current_user

    if @user.update(whitelisted_params)
      @user.addresses.build
      flash[:success] = "User updated"
      redirect_to products_path
    else
      flash[:error] = "Failed to update user"
      render 'edit'
    end
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
