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
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "New User Created!"
      redirect_to admin_user_path(@user)
    else
      flash.now[:danger] = "Oops, something went wrong!"
      render :new
    end
  end


  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:info] = "User Updated."
      redirect_to admin_user_path(@user)
    else
      flash.now[:danger] = "Oops, something went wrong!"
      render :edit
    end
  end


  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:warning] = "User deleted."
      redirect_to admin_users_path
    else
      flash[:danger] = "User could not be deleted!"
      redirect_to :back
    end
  end


  private


  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :billing_id,
                                 :shipping_id)
  end

end
