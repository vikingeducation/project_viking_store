class UsersController < ApplicationController
  layout "admin"

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(whitelisted_user_params)
    if @user.save
      flash[:success] = "User created!"
      redirect_to users_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render "/users/new"
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "User obliterated!"
      redirect_to users_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render "/users"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(whitelisted_user_params)
      flash[:success] = "User updated!"
      redirect_to users_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render "users/edit"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def whitelisted_user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
