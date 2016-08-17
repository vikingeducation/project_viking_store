class UsersController < ApplicationController
  def index
    @users = User.all
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
      flash[:success] = "User Successfully Updated"
      redirect_to user_path(@user.id)
    else
      flash[:error] = "Something went wrong"
      render :edit
    end
  end

  def new
    @user = User.new
    #2.times { @user.addresses.build }
  end

  def create
    @user = User.new(whitelisted_params)
    if @user.save
      flash[:success] = "User successfully created"
      redirect_to user_path(@user.id)
    else
      flash[:error] = "Something went wrong"
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "User Destroyed"
      redirect_to users_path
    else
      flash[:error] = "Something went wrong"
      redirect_to :back
    end
  end

  private

  def whitelisted_params
    params.require(:user).permit(:first_name, :last_name, :email, :shipping_id, :billing_id)
  end
end
