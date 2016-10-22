class Admin::UsersController < AdminController
  layout 'admin'

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
      flash[:success] = "You have successfully created a user"
      redirect_to admin_users_path
    else
      flash[:error] = "Something went wrong"
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(whitelisted_user_params)
      flash[:success] = "user successfully updated"
      redirect_to admin_users_path
    else
      flash[:error] = "Something went wrong updating your user"
      render :edit
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
     @user = User.find(params[:id])

    if @user.destroy
      flash[:success] = "User was successfully destroyed"
      redirect_to admin_users_path
    else
      flash[:error] = "Could not delete User"
      redirect_to :back
    end
  end

  private

  def whitelisted_user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

end
