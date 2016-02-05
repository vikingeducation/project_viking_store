class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "You've Sucessfully Created a User!"
      redirect_to user_path(@user)
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



end
