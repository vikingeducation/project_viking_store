class UsersController < ApplicationController
  layout "shop"
  def new
    @user = User.new
    @user.addresses.build
    @user.addresses.build
  end

  def create
    @user = User.new(whitelisted_params)
    if @user.save
      flash[:success] = "#{@user.full_name} is now living"
      redirect_to root_path
    else
      flash.now[:danger] = "Something wrong happen"
      @user.addresses.build
      @user.addresses.build
      render :new
    end
  end

  def edit
    @user = current_user
    @user.addresses.build
  end

  def update
    @user = current_user
    if @user.update_attributes(whitelisted_params)
      flash[:success] = "User updated!"
      redirect_to root_path
    else
      flash.now[:danger] = "Something went wrong"
      @user.addresses.build
      render :edit
    end
  end

  def destroy
    @user = current_user
    if @user.delete
      flash[:success] = "User Succesfully Deleted"
      signout
      redirect_to root_path
    else
      flash[:danger] = "The user was NOT deleted"
      redirect_to(:back)
    end
  end

  private

  def whitelisted_params
    params.require(:user).permit(:first_name, :last_name, :email, :email_confirmation,
                                 addresses_attributes: [:id, :user_id, :street_address, :state_id, :zip_code, :city_id, :_destroy])
  end
end
