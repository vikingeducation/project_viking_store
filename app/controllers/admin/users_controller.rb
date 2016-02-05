class Admin::UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(whitelisted_params)
    if @user.save
      flash[:success] = 'New user created.'
      redirect_to admin_user_path(user)
    else
      flash[:error] = 'Failed to create user.'
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @full_name = @user.full_name
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(whitelisted_params)
      flash[:success] = 'User updated.'
      redirect_to admin_user_path(@user)
    else
      flash[:error] = 'Failed to update user.'
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = 'User destroyed.'
      redirect_to admin_users_path
    else
      flash[:error] = 'Failed to destroy user.'
      render 'show'
    end
  end

  private

  def whitelisted_params
    params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id)
  end

end
