class UsersController < ApplicationController
  def index
    @users = User.all.first(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(white_listed_params)
      redirect_to @user
    else
      render "edit"
    end
  end

  def create
    @user = User.new(white_listed_params)

    if @user.save
      redirect_to @user
    else
      render "new"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path
  end

  private

  def white_listed_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

end
