class Admin::UsersController < AdminController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(whitelisted_user_params)
    if @user.save
      flash[:success] = "User created successfully."
      redirect_to users_path
    else
      flash.now[:error] = "Failed to create User."
      render 'new'
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
    if @user.update_attributes(whitelisted_user_params)
      flash[:success] = "User updated successfully."
      redirect_to users_path
    else
      flash.now[:error] = "Failed to update User."
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    session[:return_to] ||= request.referer
    if @user.destroy
      flash[:success] = "User deleted successfully."
      redirect_to users_path
    else
      flash[:error] = "Failed to delete User."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def whitelisted_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id, :phone_number)
  end
end
