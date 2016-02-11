class UsersController < ApplicationController

  before_action :require_login, :except => [:new, :create]
  before_action :require_current_user, :only => [:edit, :update, :destroy]

  def index
    @users = User.get_user_info
  end

  def new
    @user = User.new
    @user.addresses.build
    @user.addresses.build
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "You've Sucessfully Created an User!"
      redirect_to user_path(@user)
    else
      flash.now[:error] = "Error! User wasn't created!"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @user_info = User.get_detailed_user_info(@user)
  end

  def edit
    @user = User.find(params[:id])
    @user_info = User.get_detailed_user_info(@user)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "You've Sucessfully Updated the User!"
      redirect_to user_path(@user)
    else
      flash.now[:error] = "Error! User wasn't updated!"
      render :edit
    end
  end

  def destroy
     @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "You've Sucessfully Deleted the User!"
      redirect_to users_path
    else
      flash.now[:error] = "Error! User wasn't deleted!"
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name, 
      :last_name, 
      :email, 
      :shipping_id, 
      :billing_id,
      { :addresses_attributes => [
        :street_address,
        :city,
        :state,
        :zip ] }
    )
  end

  def require_current_user
    unless current_user == User.find(params[:id])
      flash[:error] = "Access denied!!!"
      redirect_to root_url
    end
  end
end
