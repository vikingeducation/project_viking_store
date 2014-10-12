class UsersController < ApplicationController

  def index
    @users = User.all
    render :layout => "admin_interface"
  end

  def show
    @user = User.find(params[:id])
    render :layout => "admin_interface"
  end

  def new
    @user = User.new
    render :layout => "admin_interface"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "New User \"#{@user.first_name} #{@user.last_name}\" has been successfully created!"
      redirect_to users_path
    else
      flash[:error] = "User was not created, please try again"
      render 'new'
    end
  end


  # ---- utility methods ----

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name,
         :email, :phone, :default_billing_address_id,
         :default_shipping_address_id)
  end


end
