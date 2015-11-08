class Admin::AddressesController < AdminController

  def index
    if params[:user_id] && User.exists?(params[:user_id])
      @user = User.find(params[:user_id])
      @addresses = @user.addresses
    elsif params[:user_id]
      flash[:danger] = "Invalid User!"
      @addresses = Address.all
    else
      @addresses = Address.all
    end
  end

end
