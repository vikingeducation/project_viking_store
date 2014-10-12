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
    @addresses = get_valid_addresses
    render :layout => "admin_interface"
  end

  def create
    @user = User.new(user_params)
    @addresses = get_valid_addresses
    if @user.save
      flash[:success] = "New User \"#{@user.first_name} #{@user.last_name}\" has been successfully created!"
      redirect_to @user
    else
      flash[:error] = "User was not created, please try again"
      render 'new'
    end
  end

  def edit
    @user =User.find(params[:id])
    @addresses = get_valid_addresses
  end




  def update
    @user = User.find(params[:id])
    @addresses = get_valid_addresses
    if @user.update(user_params)
      flash[:success] = "User \"#{@user.first_name} #{@user.last_name}\" has been successfully updated!"
      redirect_to users_path
    else
      flash.now[:error] = "User did not update, please try again"
      render 'edit' # something wasn't right, give them another chance
    end

  end

  def destroy
    @user = User.find(params[:id])
    if User.find(params[:id]).destroy
      flash[:success] = "User #{@user.first_name} #{@user.last_name} deleted."
      redirect_to users_path
    else
      redirect_to @user
    end
  end

  # ---- utility methods ----

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name,
         :email, :phone, :default_billing_address_id,
         :default_shipping_address_id)
  end

  def get_valid_addresses
      Address.where(user_id: @user.id)
  end

end
