class UsersController < ApplicationController

  layout "admin", only: [:index, :new, :show, :edit]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @credit_cards = @user.credit_cards
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new whitelisted_user_params
    if @user.save
      flash[:success] = "You created a new user."
      redirect_to users_path
    else
      flash[:error] = "There was an error."
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update whitelisted_user_params
      flash[:success] = "You updated this user."
      redirect_to user_path(@user.id)
    else
      flash[:error] = "Something is wrong."
      render :edit
    end
  end

  def destroy
    
  end

  private

  def whitelisted_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :shipping_id, :billing_id)
  end
end
