class Admin::UsersController <  AdminController
  def index
    @users = User.get_user_info
  end

  def new
    @user = User.new
    @address = Address.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "You've Sucessfully Created an User!"
      redirect_to [:admin, user_path(@user)]
    else
      flash.now[:error] = "Error! User wasn't created!"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @user_info = User.get_detailed_user_info(@user)
  end

  def edit
    @user = User.find(params[:id])
    @user_info = User.get_detailed_user_info(@user)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "You've Sucessfully Updated the User!"
      redirect_to admin_user_path(@user)
    else
      flash.now[:error] = "Error! User wasn't updated!"
      render :edit
    end
  end

  def destroy
     @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "You've Sucessfully Deleted the User!"
      redirect_to [:admin, users_path]
    else
      flash.now[:error] = "Error! User wasn't deleted!"
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :shipping_id, :billing_id)
  end
end
