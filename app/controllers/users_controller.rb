class UsersController < ApplicationController
  
  def index
    @admin_info = User.admin_info
  end

  def new
    @user = User.new
  end

  def create
     @user = User.new(user_form_params)
    if @user.save
      flash[:success] = "User created successfully."
      redirect_to user_path(@user)
    else
      flash[:error] = "User not created"
      render :index
    end
  end

  def show
    @user = User.find(params[:id])
    @address = Address.where(:user_id => @user.id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
     @user = User.find(params[:id])
    if @user.update_attributes(user_form_params)
    flash[:success] = "User updated successfully."
    redirect_to user_path(@user)
    else
      flash[:error] = "User not updated"
      render :show
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "User deleted successfully."
      redirect_to users_path
    else
      flash[:error] = "User not deleted"
      redirect_to session.delete(:return_to)
    end
  end

  
private
  def user_form_params
    params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id)
  end
end
