class Admin::UsersController < AdminController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(whitelisted_user_params)
    if @user.save
      flash[:success] = "'#{@user.first_name} #{@user.last_name}' successfully created"
      redirect_to user_path(@user)
    else
      render :new
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
    if @user.update(whitelisted_user_params)
      flash[:success] = "'#{@user.first_name} #{@user.last_name}' successfully updated"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "'#{@user.first_name} #{@user.last_name}' successfully deleted"
    else
      flash[:error] = "Unable to delete '#{@user.first_name} #{@user.last_name}'"
    end
    redirect_to users_path
  end





  private

  def whitelisted_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :telephone)
  end

end
