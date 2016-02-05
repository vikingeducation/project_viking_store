class UsersController < ApplicationController
  def index
    @users = User.get_all_with_billing_location
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "You've Sucessfully Created a User!"
      redirect_to user_path(@user.id)
    else
      flash.now[:error] = "Error! User wasn't created!"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @billing = User.get_billing_address(@user.id)
    @shipping = User.get_shipping_address(@user.id)
    @credit_card = User.get_credit_card(@user.id)
    @orders = User.get_orders(@user.id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "You've Sucessfully Deleted a User!"
      redirect_to users_path
    else
      flash.now[:error] = "Error! User wasn't deleted!"
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id)
  end

end
