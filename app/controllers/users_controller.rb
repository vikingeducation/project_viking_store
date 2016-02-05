class UsersController < ApplicationController
  layout "admin"

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user.User.create(whitelisted_user_params)
    if @user.save
      flash[:success] = "'#{user.firstname} #{user.lastname} successfully created"
      redirect_to users_path
    else
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
    if @user.update(whitelisted_user_params)
      flash[:success] = "'#{user.firstname} #{user.lastname} successfully updated"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "'#{user.firstname} #{user.lastname} successfully deleted"
    else
      flash[:error] = "Unable to delete '#{user.firstname} #{user.lastname}"
    end
    redirect_to users_path
  end







  private

  def whitelisted_user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

end
