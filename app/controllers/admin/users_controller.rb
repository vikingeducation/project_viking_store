class Admin::UsersController < AdminController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'User created!'
      redirect_to admin_users_path
    else
      flash.now[:alert] = 'Error: user not created'
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'User updated!'
      redirect_to admin_user_path(@user)
    else
      flash.now[:alert] = 'Error: user not updated'
      render :edit
    end
  end

  def show
  end

  def destroy
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id)
  end
end
