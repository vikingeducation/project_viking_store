class UsersController < ApplicationController
  layout 'admin'

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "A new User has been created!"
      @user = User.last
      render :show
    else
      flash[:error] = "User creation failed! Correct your errors!"
      @user = User.new
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "The User has been updated!"
      render :show
    else
      flash[:error] = "User update failed! Correct your errors!"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "Your User has been deleted!"
    else
      flash[:error] = "Error! The User lives on!"
    end
    @users = User.all
    render :index
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id)
  end

end
