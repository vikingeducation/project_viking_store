class Admin::UsersController < ApplicationController

  layout 'admin_portal_layout'

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
    @user = User.new(whitelisted_user_params)
    if @user.save
      flash[:success] = "New User has been created"
      redirect_to admin_user_path(@user.id)
    else
      flash.now[:danger] = "The user could not be created. Try again."
      render 'new', :locals => {:user => @user}
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(whitelisted_user_params)
      flash[:success] = "The user has been successfully updated"
      redirect_to admin_user_path(@user.id)
    else
      flash.now[:danger] = "The user cannot be updated."
      render 'edit', :locals => {:user => @user}
    end
  end

  # def destroy
  #   @product = User.find(params[:id])
  #   if @User.destroy
  #     flash[:success] = "Product deleted successfully!"
  #     redirect_to admin_users_path
  #   else
  #     flash[:danger] = "Failed to delete product"
  #     redirect_to request.referer
  #   end
  # end



  private
  def whitelisted_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id)
  end

end
