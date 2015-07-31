class Admin::UsersController < AdminController
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
    @user = User.new(whitelist_user_params)
    if @user.save
      flash[:success] = "New User #{@user.name} successfully created!"
      redirect_to admin_user_path(@user)
    else
      flash.now[:danger] = "Failed to create new user. Please Try again."
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(whitelist_user_params)
      flash[:success] = "User #{@user.name} successfully updated!"
      redirect_to admin_user_path(@user)
    else
      flash.now[:danger] = "Failed to update user. Please try again."
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "User #{@user.name} successfully deleted!"
      redirect_to admin_users_path
    else
      flash.now[:danger] = "Failed to delete user. Please try again."
      redirect_to admin_user_path(@user)
    end
  end

  private
    def whitelist_user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
end
