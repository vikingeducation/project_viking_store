class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(whitelist_user_params)
    if @user.save
      flash[:success] = "New User #{@user.name} successfully created!"
      redirect_to @user
    else
      flash[:danger] = "Failed to create new user. Please Try again."
      render :new
    end
  end

  private
    def whitelist_user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
end
