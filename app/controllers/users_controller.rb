class UsersController < AdminController

  layout "application"

  def index

  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id)
  end

end
