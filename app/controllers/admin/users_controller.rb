class Admin::UsersController < AdminController

  def index
    @users = User.all

    @last_date = {}

    @users.each do |user|
      @last_date[user.id] = User.last_order_date(user.id)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(whitelisted_params)
    if @user.save
      flash.notice = "You created User"
      redirect_to admin_user_path(@user)
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

    if @user.update(whitelisted_params)
      flash.notice = "You updated User"
      redirect_to admin_user_path(@user)
    else
      flash.now.notice = "It failed to update"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    @user.destroy
    flash.notice = "You deleted User"
    redirect_to admin_users_path
  end


  private

    def whitelisted_params
      params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id)
    end
end
