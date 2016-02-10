class Shop::UsersController < ShopController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Account for #{@user.full_name} created!"
      redirect_to shop_products_path
    else
      flash[:error] = "Account creation not successful"
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Account for #{@user.full_name} updated!"
      redirect_to shop_products_path
    else
      flash[:error] = "Account update not successful"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

end
