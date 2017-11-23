class Admin::UsersController < ApplicationController

  layout 'admin_portal_layout'

  def index
    @users = User.all
  end


  def new
    @user = User.new
  end


  def create
    @user = User.new(whitelisted_params)
    if @user.save
      flash[:success] = "User Successfully Saved!"
      redirect_to admin_users_path
    else
      flash[:danger] = "User Could Not Be Saved See Errors On Form"
      render :new
    end
  end


  def show
    @user = User.find(params[:id])
  end


  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    if @user.update(whitelisted_params)
      flash[:success] = "User Successfully Updated!"
      redirect_to admin_user_path(params[:id])
    else
      flash[:danger] = "User Could Not Be Updated See Errors On Form"
      render :edit
    end
  end


  def destroy
    if @user.destroy
      flash[:success] = "User Successfully Deleted"
      redirect_to admin_users_path
    else
      flash[:danger] = "Could Not Delete User"
      redirect_to admin_user_path(@user)
    end
  end


  private

  def whitelisted_params
    params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id, :telephone)
  end

end
